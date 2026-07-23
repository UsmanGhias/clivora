#!/usr/bin/env python3
"""Import password-encrypted Play upload key export → android/clivora-upload-keystore.jks.

The paste from Android Studio / keytool export is:
  version(u32 BE)=1
  utf alias
  creationDate(u64 BE ms)
  encryptedPrivateKeyInfo (JKS KeyProtector OID 1.3.6.1.4.1.42.2.17.1.1)
  utf "X.509"
  certificate DER

Requires CLIVORA_UPLOAD_KEY_PASSWORD (or ANDROID_KEYSTORE_PASSWORD).
Never commit the resulting .jks or key.properties.
"""
from __future__ import annotations

import argparse
import hashlib
import os
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

EXPECTED_SHA1 = "96:93:81:80:EE:59:27:D2:46:B2:BD:FC:6C:96:C6:93:2E:1A:1D:36"
ROOT = Path(__file__).resolve().parents[1]
DEFAULT_EXPORT = ROOT / "android" / ".signing" / "clivora-upload.export"
DEFAULT_JKS = ROOT / "android" / "clivora-upload-keystore.jks"
DEFAULT_PROPS = ROOT / "android" / "key.properties"


def _take_len(buf: bytes, i: int) -> tuple[int, int]:
    if buf[i] & 0x80 == 0:
        return buf[i], i + 1
    n = buf[i] & 0x7F
    val = int.from_bytes(buf[i + 1 : i + 1 + n], "big")
    return val, i + 1 + n


def parse_encrypted_private_key_info(ek: bytes) -> bytes:
    if ek[0] != 0x30:
        raise ValueError("EncryptedPrivateKeyInfo must be a SEQUENCE")
    i = 1
    _, i = _take_len(ek, i)
    if ek[i] != 0x30:
        raise ValueError("missing algorithm SEQUENCE")
    i += 1
    alg_len, i = _take_len(ek, i)
    i += alg_len
    if ek[i] != 0x04:
        raise ValueError("missing encrypted OCTET STRING")
    i += 1
    ct_len, i = _take_len(ek, i)
    return ek[i : i + ct_len]


def jks_keyprotector_decrypt(encrypted: bytes, password: str) -> bytes:
    """Decrypt SunJKS KeyProtector ciphertext → PKCS#8 PrivateKeyInfo DER."""
    if len(encrypted) < 40:
        raise ValueError("ciphertext too short")
    salt, edata = encrypted[:20], encrypted[20:]
    pb = bytearray(len(password) * 2)
    for idx, ch in enumerate(password):
        pb[idx * 2] = (ord(ch) >> 8) & 0xFF
        pb[idx * 2 + 1] = ord(ch) & 0xFF
    pb_b = bytes(pb)
    encr_key_len = len(edata) - 20
    digest = salt
    parts: list[bytes] = []
    for _ in range((encr_key_len + 19) // 20):
        h = hashlib.sha1()
        h.update(pb_b)
        h.update(digest)
        digest = h.digest()
        parts.append(digest)
    xor_key = b"".join(parts)[:encr_key_len]
    plain_key = bytes(a ^ b for a, b in zip(edata[:encr_key_len], xor_key))
    checksum = edata[encr_key_len:]
    h = hashlib.sha1()
    h.update(pb_b)
    h.update(plain_key)
    if h.digest() != checksum:
        raise ValueError("wrong password (KeyProtector checksum mismatch)")
    return plain_key


def parse_export(data: bytes) -> tuple[str, bytes, bytes]:
    i = 0
    version = struct.unpack(">I", data[i : i + 4])[0]
    i += 4
    if version not in (1, 0x10):
        # tolerate corrupt leading bytes seen in terminal pastes
        if data[2:6] == b"\x00\x00\x00\x01":
            i = 2
            version = struct.unpack(">I", data[i : i + 4])[0]
            i += 4
        else:
            raise ValueError(f"unsupported export version {version:#x}")
    ulen = struct.unpack(">H", data[i : i + 2])[0]
    i += 2
    alias = data[i : i + ulen].decode("utf-8")
    i += ulen
    i += 8  # creation date
    eklen = struct.unpack(">I", data[i : i + 4])[0]
    i += 4
    ek = data[i : i + eklen]
    i += eklen
    ulen = struct.unpack(">H", data[i : i + 2])[0]
    i += 2
    ctype = data[i : i + ulen]
    i += ulen
    if ctype != b"X.509":
        raise ValueError(f"unexpected cert type {ctype!r}")
    clen = struct.unpack(">I", data[i : i + 4])[0]
    i += 4
    cert = data[i : i + clen]
    return alias, ek, cert


def write_keystore(pkcs8: bytes, cert: bytes, alias: str, password: str, dest: Path) -> None:
    with tempfile.TemporaryDirectory() as td:
        tdp = Path(td)
        (tdp / "key.pk8").write_bytes(pkcs8)
        (tdp / "cert.der").write_bytes(cert)
        # PKCS#8 → PEM key + PEM cert → PKCS12 → JKS
        subprocess.check_call(
            [
                "openssl",
                "pkcs8",
                "-inform",
                "DER",
                "-nocrypt",
                "-in",
                str(tdp / "key.pk8"),
                "-out",
                str(tdp / "key.pem"),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        subprocess.check_call(
            [
                "openssl",
                "x509",
                "-inform",
                "DER",
                "-in",
                str(tdp / "cert.der"),
                "-out",
                str(tdp / "cert.pem"),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        subprocess.check_call(
            [
                "openssl",
                "pkcs12",
                "-export",
                "-inkey",
                str(tdp / "key.pem"),
                "-in",
                str(tdp / "cert.pem"),
                "-name",
                alias,
                "-out",
                str(tdp / "upload.p12"),
                "-passout",
                f"pass:{password}",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists():
            dest.unlink()
        subprocess.check_call(
            [
                "keytool",
                "-importkeystore",
                "-noprompt",
                "-srckeystore",
                str(tdp / "upload.p12"),
                "-srcstoretype",
                "PKCS12",
                "-srcstorepass",
                password,
                "-srcalias",
                alias,
                "-destkeystore",
                str(dest),
                "-deststoretype",
                "JKS",
                "-deststorepass",
                password,
                "-destkeypass",
                password,
                "-destalias",
                alias,
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def verify_sha1(jks: Path, alias: str, password: str) -> str:
    out = subprocess.check_output(
        [
            "keytool",
            "-list",
            "-v",
            "-keystore",
            str(jks),
            "-alias",
            alias,
            "-storepass",
            password,
        ],
        text=True,
        stderr=subprocess.DEVNULL,
    )
    for line in out.splitlines():
        if "SHA1:" in line.upper().replace(" ", "") or line.strip().startswith("SHA1:"):
            # keytool prints "\t SHA1: AA:BB:..."
            if "SHA1:" in line:
                return line.split("SHA1:", 1)[1].strip().upper()
    raise RuntimeError("could not read SHA1 from keystore")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--export", type=Path, default=DEFAULT_EXPORT)
    ap.add_argument("--out-jks", type=Path, default=DEFAULT_JKS)
    ap.add_argument("--out-props", type=Path, default=DEFAULT_PROPS)
    ap.add_argument(
        "--password",
        default=os.environ.get("CLIVORA_UPLOAD_KEY_PASSWORD")
        or os.environ.get("ANDROID_KEYSTORE_PASSWORD")
        or "",
    )
    args = ap.parse_args()
    if not args.password:
        print(
            "ERROR: set CLIVORA_UPLOAD_KEY_PASSWORD (or ANDROID_KEYSTORE_PASSWORD)",
            file=sys.stderr,
        )
        return 1
    if not args.export.is_file():
        print(f"ERROR: export not found: {args.export}", file=sys.stderr)
        return 1

    alias, ek, cert = parse_export(args.export.read_bytes())
    try:
        pkcs8 = jks_keyprotector_decrypt(parse_encrypted_private_key_info(ek), args.password)
    except ValueError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 2

    write_keystore(pkcs8, cert, alias, args.password, args.out_jks)
    sha1 = verify_sha1(args.out_jks, alias, args.password)
    if sha1 != EXPECTED_SHA1:
        print(f"ERROR: SHA1 mismatch: got {sha1}, expected {EXPECTED_SHA1}", file=sys.stderr)
        return 3

    args.out_props.write_text(
        "\n".join(
            [
                f"storePassword={args.password}",
                f"keyPassword={args.password}",
                f"keyAlias={alias}",
                "storeFile=clivora-upload-keystore.jks",
                "",
            ]
        )
    )
    print(f"Wrote {args.out_jks}")
    print(f"Wrote {args.out_props}")
    print(f"Upload keystore OK (SHA1 {sha1})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

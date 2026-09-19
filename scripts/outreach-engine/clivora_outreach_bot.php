<?php
/**
 * CLIVORA & CODCRAFTERS 24/7 AUTONOMOUS CLOUD OUTREACH ENGINE
 * Runs continuously in Hostinger Cloud via Scheduled Cron.
 * Strictly adheres to max 95 emails/day quota and zero-spam guidelines.
 * Powered by official Hostinger TLS SMTP (smtp.hostinger.com:465).
 * (No em-dashes anywhere).
 */

ini_set('display_errors', 0);
ini_set('log_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');

$SECURITY_KEY = "UsmanCareerBot2026";
$req_key = $_GET['key'] ?? ($_POST['key'] ?? '');
$test_to = $_GET['test_to'] ?? ($_POST['test_to'] ?? '');
$action = $_GET['action'] ?? ($_POST['action'] ?? '');

$is_cli = (php_sapi_name() === 'cli');
// Every action that sends mail or reads/writes leads requires CLI (cron) or the security key.
$is_authorized = $is_cli || (is_string($req_key) && $req_key !== '' && hash_equals($SECURITY_KEY, $req_key));

// Hostinger MySQL Connection
$db_hosts = ['localhost', 'srv1415.hstgr.io', '127.0.0.1'];
$db_name = 'u275200862_jobs_db';
$db_user = 'u275200862_jobs_user';
$db_pass = 'UsmanJobs2026!#';

$pdo = null;
foreach ($db_hosts as $h) {
    try {
        $pdo = new PDO("mysql:host={$h};dbname={$db_name};charset=utf8mb4", $db_user, $db_pass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_TIMEOUT => 3
        ]);
        break;
    } catch (Exception $e) {}
}

if (!$pdo) {
    $sqlite_dir = __DIR__ . '/data';
    if (!is_dir($sqlite_dir)) mkdir($sqlite_dir, 0755, true);
    $pdo = new PDO("sqlite:" . $sqlite_dir . '/outreach_tracker.db');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}

$driver = $pdo->getAttribute(PDO::ATTR_DRIVER_NAME);

// Ensure database table exists
if ($driver === 'mysql') {
    $pdo->exec("CREATE TABLE IF NOT EXISTS clivora_outreach_leads (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(191) UNIQUE,
        name VARCHAR(255),
        company VARCHAR(255),
        role VARCHAR(255),
        segment VARCHAR(50),
        status VARCHAR(50) DEFAULT 'PENDING',
        sent_at DATETIME NULL,
        response_log TEXT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
} else {
    $pdo->exec("CREATE TABLE IF NOT EXISTS clivora_outreach_leads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        name TEXT,
        company TEXT,
        role TEXT,
        segment TEXT,
        status TEXT DEFAULT 'PENDING',
        sent_at TEXT,
        response_log TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )");
}

// Auto-seed initial directory if empty
try {
    $lead_count_stmt = $pdo->query("SELECT COUNT(*) FROM clivora_outreach_leads");
    if ((int)$lead_count_stmt->fetchColumn() === 0) {
        $seed_leads = [
            ['email' => 'founder@novatech.io', 'name' => 'Marcus Vance', 'company' => 'NovaTech Solutions', 'role' => 'CEO & Founder', 'segment' => 'CLIENT'],
            ['email' => 'cto@apexcloud.dev', 'name' => 'Elena Rostova', 'company' => 'Apex Cloud Systems', 'role' => 'Chief Technology Officer', 'segment' => 'CLIENT'],
            ['email' => 'engineering@quantumltd.co', 'name' => 'David Chen', 'company' => 'Quantum Digital Ltd', 'role' => 'VP of Engineering', 'segment' => 'CLIENT'],
            ['email' => 'operations@vortexagency.com', 'name' => 'Sarah Jenkins', 'company' => 'Vortex Digital Agency', 'role' => 'Managing Director', 'segment' => 'CLIENT'],
            ['email' => 'tech@stratosglobal.net', 'name' => 'Alexander Wright', 'company' => 'Stratos Global', 'role' => 'Head of Product', 'segment' => 'CLIENT'],
            ['email' => 'leadership@luminari.co', 'name' => 'Claire Dubois', 'company' => 'Luminari Media Labs', 'role' => 'Founder & COO', 'segment' => 'CLIENT'],
            ['email' => 'hello@prismadigital.io', 'name' => 'Julian Morales', 'company' => 'Prisma Digital Group', 'role' => 'Partner', 'segment' => 'CLIENT'],
            ['email' => 'projects@hyperiontech.uk', 'name' => 'Liam O\'Connor', 'company' => 'Hyperion Technologies', 'role' => 'Technical Director', 'segment' => 'CLIENT'],
            ['email' => 'founders@synapselabs.ai', 'name' => 'Priya Sharma', 'company' => 'Synapse Labs AI', 'role' => 'Co-Founder', 'segment' => 'CLIENT'],
            ['email' => 'partners@koreagencies.com', 'name' => 'Daniel Kim', 'company' => 'Kore Agency Network', 'role' => 'Principal', 'segment' => 'CLIENT'],
            ['email' => 'partnerships@cloudscale.io', 'name' => 'Rachel Adams', 'company' => 'CloudScale Ecosystems', 'role' => 'Head of Partnerships', 'segment' => 'SPONSOR'],
            ['email' => 'sponsors@techsummitglobal.org', 'name' => 'Michael Sterling', 'company' => 'Global Tech Summits', 'role' => 'Sponsorship Director', 'segment' => 'SPONSOR'],
            ['email' => 'community@devstack.network', 'name' => 'Sophie Martin', 'company' => 'DevStack Community', 'role' => 'Community Lead', 'segment' => 'SPONSOR'],
            ['email' => 'ventures@frontierseed.vc', 'name' => 'Arthur Pendelton', 'company' => 'Frontier Seed Capital', 'role' => 'Investment Principal', 'segment' => 'SPONSOR'],
            ['email' => 'ecosystem@hypernode.dev', 'name' => 'Tariq Al-Mansoor', 'company' => 'HyperNode Infrastructure', 'role' => 'Ecosystem Architect', 'segment' => 'SPONSOR'],
            ['email' => 'growth@saasbuilders.club', 'name' => 'Hannah Schmidt', 'company' => 'SaaS Builders Network', 'role' => 'Growth Partner', 'segment' => 'SPONSOR'],
            ['email' => 'programs@innovateaccelerator.com', 'name' => 'Carlos Rivera', 'company' => 'Innovate Global Accelerator', 'role' => 'Program Director', 'segment' => 'SPONSOR'],
            ['email' => 'dev@alexmorgan.tech', 'name' => 'Alex Morgan', 'company' => 'Independent Consultant', 'role' => 'Full-Stack Engineer', 'segment' => 'FREELANCER'],
            ['email' => 'contact@victoriasmith.design', 'name' => 'Victoria Smith', 'company' => 'Design Studio', 'role' => 'UI/UX Designer', 'segment' => 'FREELANCER'],
            ['email' => 'tarik@cloudnative.guru', 'name' => 'Tarik Benali', 'company' => 'DevOps Advisory', 'role' => 'Kubernetes Architect', 'segment' => 'FREELANCER']
        ];
        $insert_sql = ($driver === 'sqlite') ? "INSERT OR IGNORE INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING')" : "INSERT IGNORE INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
        $ins = $pdo->prepare($insert_sql);
        foreach ($seed_leads as $sl) {
            $ins->execute([$sl['email'], $sl['name'], $sl['company'], $sl['role'], $sl['segment']]);
        }
    }
} catch (Exception $e) {}

// Official Professional Clivora Hostinger Mailbox Senders
$CLIVORA_SENDERS = [
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "growth@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "growth@clivora.io",
        "from_name" => "Usman Ghias · Clivora & CODCrafters"
    ],
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "hello@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "hello@clivora.io",
        "from_name" => "Clivora Ecosystem"
    ],
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "contact@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "contact@clivora.io",
        "from_name" => "Usman Ghias · Principal Architect"
    ],
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "marketing@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "marketing@clivora.io",
        "from_name" => "Clivora Community & Growth"
    ],
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "partners@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "partners@clivora.io",
        "from_name" => "Clivora Strategic Partnerships"
    ],
    [
        "smtp_host" => "ssl://smtp.hostinger.com",
        "smtp_port" => 465,
        "auth_user" => "usmanghias@clivora.io",
        "auth_pass" => "46730820Hangb@?!;Usman",
        "from_email" => "usmanghias@clivora.io",
        "from_name" => "Usman Ghias (Founder)"
    ]
];

// Check Daily Quota (Max 95 sends per calendar day)
$MAX_DAILY_QUOTA = 95;
$today_sent = 0;
$total_sent_lifetime = 0;
$pending_leads_count = 0;

try {
    $today_clause = ($driver === 'sqlite') ? "DATE(sent_at) = DATE('now')" : "DATE(sent_at) = CURDATE()";
    $stmt = $pdo->query("SELECT COUNT(*) FROM clivora_outreach_leads WHERE {$today_clause} AND status = 'SENT'");
    $today_sent = (int)$stmt->fetchColumn();
    $total_sent_lifetime = (int)$pdo->query("SELECT COUNT(*) FROM clivora_outreach_leads WHERE status = 'SENT'")->fetchColumn();
    $pending_leads_count = (int)$pdo->query("SELECT COUNT(*) FROM clivora_outreach_leads WHERE status = 'PENDING'")->fetchColumn();
} catch (Exception $e) {}

// SMTP Dispatch Function via SSL/TLS Socket
function send_cloud_smtp($sender, $to, $subject, $html_body, $plain_text) {
    $host = $sender['smtp_host'] ?? 'ssl://smtp.hostinger.com';
    $port = $sender['smtp_port'] ?? 465;

    $socket = @fsockopen($host, $port, $errno, $errstr, 20);
    if (!$socket) throw new Exception("Could not connect to SMTP host: {$errstr} ({$errno})");

    $log = '';
    $read_reply = function($socket, &$log) {
        $data = '';
        while ($line = fgets($socket, 512)) {
            $data .= $line;
            if (substr($line, 3, 1) === ' ') break;
        }
        $log .= $data;
        return $data;
    };

    $send_cmd = function($socket, $cmd, &$log) use ($read_reply) {
        fputs($socket, $cmd . "\r\n");
        return $read_reply($socket, $log);
    };

    $read_reply($socket, $log);
    $send_cmd($socket, "EHLO clivora.io", $log);
    $send_cmd($socket, "AUTH LOGIN", $log);
    $send_cmd($socket, base64_encode($sender['auth_user']), $log);
    $auth_res = $send_cmd($socket, base64_encode($sender['auth_pass']), $log);

    if (strpos($auth_res, '235') === false) {
        fclose($socket);
        throw new Exception("SMTP Authentication failed: " . $auth_res);
    }

    $send_cmd($socket, "MAIL FROM:<{$sender['auth_user']}>", $log);
    $send_cmd($socket, "RCPT TO:<{$to}>", $log);
    $send_cmd($socket, "DATA", $log);

    $boundary = "bnd_" . md5(uniqid((string)time(), true));
    $headers = [
        "From: \"{$sender['from_name']}\" <{$sender['from_email']}>",
        "To: <{$to}>",
        "Subject: {$subject}",
        "Reply-To: <{$sender['from_email']}>",
        "MIME-Version: 1.0",
        "Content-Type: multipart/alternative; boundary=\"{$boundary}\"",
        "X-Mailer: Clivora Cloud Outreach Engine/2026",
        "List-Unsubscribe: <mailto:contact@clivora.io?subject=unsubscribe>"
    ];

    $email_raw = implode("\r\n", $headers) . "\r\n\r\n";
    $email_raw .= "--{$boundary}\r\n";
    $email_raw .= "Content-Type: text/plain; charset=UTF-8\r\n\r\n";
    $email_raw .= $plain_text . "\r\n\r\n";
    $email_raw .= "--{$boundary}\r\n";
    $email_raw .= "Content-Type: text/html; charset=UTF-8\r\n\r\n";
    $email_raw .= $html_body . "\r\n\r\n";
    $email_raw .= "--{$boundary}--\r\n.\r\n";

    fputs($socket, $email_raw);
    $send_res = $read_reply($socket, $log);
    $send_cmd($socket, "QUIT", $log);
    fclose($socket);

    if (strpos($send_res, '250') === false) {
        throw new Exception("SMTP Data rejected: " . $send_res);
    }

    return true;
}

// Google Gemini AI Engine with Free-Tier Rate-Limit Guard & Multi-Model Fallback
function generate_human_email_with_gemini($prompt, $fallback_data) {
    $api_key = "AQ.Ab8RN6LRx3eG8NnH_e46-YgiWssGDnuDEUYL7e8NOdQ4-_Nhsg";
    // Lightweight models optimized for Free-Tier quotas (15 RPM / 1,500 RPD)
    $models = ['gemini-3.1-flash-lite', 'gemini-3.5-flash-lite', 'gemini-flash-lite-latest'];

    foreach ($models as $model) {
        $endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$api_key}";
        $payload = json_encode([
            "contents" => [["parts" => [["text" => $prompt]]]],
            "generationConfig" => [
                "responseMimeType" => "application/json",
                "temperature" => 0.45,
                "maxOutputTokens" => 650
            ]
        ]);

        $ch = curl_init($endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $resp = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        // If rate-limited (429), break immediately and use pre-tuned high-converting fallback to preserve quota
        if ($http_code === 429) {
            break;
        }

        if ($http_code === 200 && $resp) {
            $json = json_decode($resp, true);
            $raw_text = $json['candidates'][0]['content']['parts'][0]['text'] ?? '';
            $parsed = json_decode($raw_text, true);
            if (!empty($parsed['subject']) && !empty($parsed['body_plain'])) {
                $html = $parsed['body_html'] ?? nl2br(htmlspecialchars($parsed['body_plain']));
                return [
                    "subject" => trim($parsed['subject']),
                    "plain" => trim($parsed['body_plain']),
                    "html" => $html,
                    "engine" => "Google Gemini AI ({$model})"
                ];
            }
        }
    }

    return array_merge($fallback_data, ["engine" => "High-Converting Human Fallback"]);
}

// Generate Personalized Pitch Content with Gemini AI
function generate_outreach_email($lead) {
    $name = htmlspecialchars($lead['name'] ?? 'Partner');
    $company = htmlspecialchars($lead['company'] ?? 'Your Organization');
    $role = htmlspecialchars($lead['role'] ?? 'Technical Lead');
    $segment = $lead['segment'] ?? 'CLIENT';

    // 1. Prepare Fallback Template
    if ($segment === 'CLIENT') {
        $fb_subject = "{$company} tech delivery & Odoo architecture scaling";
        $fb_plain = "Hi {$name},\n\nI came across your work at {$company} and wanted to reach out directly.\n\nI'm Usman Ghias, Founder of CODCrafters and creator of Clivora (https://clivora.io). We help technology teams scale custom software, high-performance Odoo 17/18 ERP implementations, and AI workflows.\n\nWe also created Clivora's Client Workspace to let companies hire and manage verified engineering talent with 0% platform commission.\n\nIf you are scaling technical capacity, check out our recent work at https://community.clivora.io/start-a-project. Let me know if you're open to a brief chat about your current roadmap.\n\nBest regards,\nUsman Ghias\nFounder, CODCrafters & Clivora\ncontact@clivora.io";
        $fb_html = "<div style='font-family: Arial, sans-serif; color: #1e293b; line-height: 1.6; max-width: 600px;'><p>Hi <strong>{$name}</strong>,</p><p>I came across your work at <strong>{$company}</strong> and wanted to reach out directly.</p><p>I'm Usman Ghias, Founder of <strong>CODCrafters</strong> and architect of <a href='https://clivora.io' style='color: #0d9488; font-weight: bold;'>Clivora</a>. We help technology teams scale custom software, high-performance Odoo 17/18 ERP implementations, and AI workflows.</p><p>We also created Clivora's Client Workspace to let companies hire and manage verified engineering talent with <strong>0% platform commission</strong>.</p><p>If you are scaling technical capacity, check out our work at <a href='https://community.clivora.io/start-a-project' style='color: #0d9488; font-weight: bold;'>https://community.clivora.io/start-a-project</a>. Let me know if you're open to a brief chat about your roadmap.</p><p style='font-size: 13px; color: #64748b; margin-top: 25px;'>Best regards,<br><strong>Usman Ghias</strong><br>Founder, CODCrafters & Clivora<br><a href='https://clivora.io' style='color: #0d9488;'>clivora.io</a> | contact@clivora.io</p></div>";
    } elseif ($segment === 'SPONSOR') {
        $fb_subject = "Partnership alignment: Clivora Community & {$company}";
        $fb_plain = "Hi {$name},\n\nI am Usman Ghias, Founder of Clivora (https://clivora.io) and CODCrafters. We operate a connected Freelancer OS and developer community (https://community.clivora.io) serving independent developers and founders worldwide.\n\nWe are currently opening strategic tracks for our Virtual Summit 2026 and API developer directory spotlight.\n\nExplore our partner tiers: https://community.clivora.io/partners. Let me know if you'd be open to a 10-minute chat next week to explore alignment.\n\nBest regards,\nUsman Ghias\nFounder, Clivora & CODCrafters\ncontact@clivora.io";
        $fb_html = "<div style='font-family: Arial, sans-serif; color: #1e293b; line-height: 1.6; max-width: 600px;'><p>Hi <strong>{$name}</strong>,</p><p>I am Usman Ghias, Founder of <a href='https://clivora.io' style='color: #0d9488; font-weight: bold;'>Clivora</a> and CODCrafters. We operate a connected Freelancer OS and developer community serving builders worldwide.</p><p>We are currently opening strategic tracks for our Virtual Summit 2026 and API developer directory spotlight.</p><p>Explore our partner tiers at <a href='https://community.clivora.io/partners' style='color: #0d9488; font-weight: bold;'>community.clivora.io/partners</a>. Let me know if you would be open for a brief 10-minute chat next week to explore alignment.</p><p style='font-size: 13px; color: #64748b; margin-top: 25px;'>Best regards,<br><strong>Usman Ghias</strong><br>Founder, Clivora & CODCrafters<br>contact@clivora.io</p></div>";
    } else {
        $fb_subject = "0% fees on independent contracts (Clivora OS)";
        $fb_plain = "Hi {$name},\n\nI built Clivora (https://clivora.io) to give independent software engineers their own operating system without traditional 10% to 20% platform commissions.\n\nIt includes 700+ verified remote jobs (https://clivora.io/jobs), milestone contracts where clients pay you directly, an integrated CRM, time tracking, and professional PDF invoicing.\n\nOpen a free workspace here: https://clivora.io/signup.\n\nBest regards,\nUsman Ghias\nFounder, Clivora & CODCrafters\nhello@clivora.io";
        $fb_html = "<div style='font-family: Arial, sans-serif; color: #1e293b; line-height: 1.6; max-width: 600px;'><p>Hi <strong>{$name}</strong>,</p><p>I built <a href='https://clivora.io' style='color: #0d9488; font-weight: bold;'>Clivora</a> to give independent software engineers their own operating system without traditional 10% to 20% platform commissions.</p><p>It includes <strong>700+ verified remote jobs</strong>, direct client contracts, integrated CRM, timer, and professional PDF invoicing.</p><p><a href='https://clivora.io/signup' style='background: #0d9488; color: #fff; padding: 9px 18px; border-radius: 6px; text-decoration: none; font-weight: bold; display: inline-block;'>Open Free Workspace &rarr;</a></p><p style='font-size: 13px; color: #64748b; margin-top: 25px;'>Best regards,<br><strong>Usman Ghias</strong><br>Founder, Clivora & CODCrafters<br>hello@clivora.io</p></div>";
    }

    $fallback = ["subject" => $fb_subject, "plain" => $fb_plain, "html" => $fb_html];

    // 2. Build High-Converting Human Prompt for Gemini
    $prompt = "You are Usman Ghias, Founder & Principal Architect at CODCrafters (https://usman.codcrafters.org) and creator of Clivora (https://clivora.io).
Write a high-converting, human B2B email to {$name}, {$role} at {$company}.

TARGET SEGMENT: {$segment}
PROVABLE VALUE PROPOSITIONS:
- Enterprise Engineering: 6+ years in production, 91+ global Odoo ERP & full-stack builds, cutting PostgreSQL query latency by 60%+ under massive concurrency.
- Clivora Business OS: Allows companies to hire & manage senior software engineers with 0% platform commissions (saving 10-20% vs traditional marketplaces).
- Portfolio & Case Studies: https://community.clivora.io/start-a-project | https://usmanghias.vercel.app

HIGH-CONVERSION RULES:
1. Subject line: Punchy, relevant, looks like an internal engineering note (e.g. 'Postgres latency / {$company} scaling' or '{$company} engineering delivery & Odoo scaling').
2. Hook: Speak to the real friction of scaling technical backends, ERP bottlenecks, or high marketplace markups.
3. Proof: Cite specific numbers (60%+ latency reduction, 91+ builds, \$0 platform fee on Clivora).
4. Low-friction CTA: Ask for a 3-minute architecture walkthrough or 10-minute sync next Tuesday.
5. Under 110 words total. NO AI clichés (NO 'I hope this email finds you well', NO 'delighted', NO 'thrilled').

Return JSON:
{
  \"subject\": \"Postgres latency / {$company} scaling\",
  \"body_plain\": \"Plain text body\",
  \"body_html\": \"Formatted HTML with links\"
}";

    $gemini_res = generate_human_email_with_gemini($prompt, $fallback);
    return [
        "subject" => $gemini_res['subject'],
        "plain" => $gemini_res['plain'] ?? $gemini_res['body_plain'],
        "html" => $gemini_res['html'] ?? $gemini_res['body_html']
    ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Test Mode: Send live sample directly to requested email
// ─────────────────────────────────────────────────────────────────────────────
if (!empty($test_to) && $is_authorized) {
    $sender = $CLIVORA_SENDERS[2]; // contact@clivora.io
    $test_lead = [
        "name" => "Usman Ghias",
        "company" => "CODCrafters & Clivora",
        "role" => "Founder & Principal Architect",
        "segment" => "CLIENT"
    ];
    $content = generate_outreach_email($test_lead);

    try {
        send_cloud_smtp($sender, $test_to, "[LIVE VERIFICATION] " . $content['subject'], $content['html'], $content['plain']);
        echo json_encode([
            "status" => "success",
            "message" => "Live test outreach email successfully dispatched to {$test_to} via Hostinger Cloud!",
            "from" => "{$sender['from_name']} <{$sender['from_email']}>",
            "subject" => "[LIVE VERIFICATION] " . $content['subject'],
            "timestamp" => date('Y-m-d H:i:s')
        ], JSON_PRETTY_PRINT);
    } catch (Exception $e) {
        echo json_encode([
            "status" => "error",
            "message" => "Failed to send test email: " . $e->getMessage()
        ], JSON_PRETTY_PRINT);
    }
    exit;
}

if ($action === 'view_leads' && $is_authorized) {
    $stmt = $pdo->query("SELECT id, email, name, company, segment, status, sent_at, response_log FROM clivora_outreach_leads ORDER BY id DESC LIMIT 50");
    echo json_encode(["status" => "success", "leads" => $stmt->fetchAll(PDO::FETCH_ASSOC)], JSON_PRETTY_PRINT);
    exit;
}

if ($action === 'seed_leads' && $is_authorized) {
    $seed_leads = [
        ['email' => 'partnerships@cloudscale.io', 'name' => 'Rachel Adams', 'company' => 'CloudScale Ecosystems', 'role' => 'Head of Partnerships', 'segment' => 'SPONSOR'],
        ['email' => 'sponsors@techsummitglobal.org', 'name' => 'Michael Sterling', 'company' => 'Global Tech Summits', 'role' => 'Sponsorship Director', 'segment' => 'SPONSOR'],
        ['email' => 'community@devstack.network', 'name' => 'Sophie Martin', 'company' => 'DevStack Community', 'role' => 'Community Lead', 'segment' => 'SPONSOR'],
        ['email' => 'ventures@frontierseed.vc', 'name' => 'Arthur Pendelton', 'company' => 'Frontier Seed Capital', 'role' => 'Investment Principal', 'segment' => 'SPONSOR'],
        ['email' => 'ecosystem@hypernode.dev', 'name' => 'Tariq Al-Mansoor', 'company' => 'HyperNode Infrastructure', 'role' => 'Ecosystem Architect', 'segment' => 'SPONSOR'],
        ['email' => 'growth@saasbuilders.club', 'name' => 'Hannah Schmidt', 'company' => 'SaaS Builders Network', 'role' => 'Growth Partner', 'segment' => 'SPONSOR'],
        ['email' => 'programs@innovateaccelerator.com', 'name' => 'Carlos Rivera', 'company' => 'Innovate Global Accelerator', 'role' => 'Program Director', 'segment' => 'SPONSOR'],
        ['email' => 'dev@alexmorgan.tech', 'name' => 'Alex Morgan', 'company' => 'Independent Consultant', 'role' => 'Full-Stack Engineer', 'segment' => 'FREELANCER'],
        ['email' => 'contact@victoriasmith.design', 'name' => 'Victoria Smith', 'company' => 'Design Studio', 'role' => 'UI/UX Designer', 'segment' => 'FREELANCER'],
        ['email' => 'tarik@cloudnative.guru', 'name' => 'Tarik Benali', 'company' => 'DevOps Advisory', 'role' => 'Kubernetes Architect', 'segment' => 'FREELANCER']
    ];
    $insert_sql = ($driver === 'sqlite') ? "INSERT OR IGNORE INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING')" : "INSERT IGNORE INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
    $ins = $pdo->prepare($insert_sql);
    $added = 0;
    foreach ($seed_leads as $sl) {
        if ($ins->execute([$sl['email'], $sl['name'], $sl['company'], $sl['role'], $sl['segment']])) {
            $added++;
        }
    }
    echo json_encode(["status" => "success", "message" => "Seeded leads successfully", "added" => $added], JSON_PRETTY_PRINT);
    exit;
}

if ($action === 'add_lead' && $is_authorized) {
    $em = $_GET['email'] ?? ($_POST['email'] ?? '');
    $nm = $_GET['name'] ?? ($_POST['name'] ?? 'Partner');
    $comp = $_GET['company'] ?? ($_POST['company'] ?? 'Enterprise');
    $rl = $_GET['role'] ?? ($_POST['role'] ?? 'Leader');
    $seg = $_GET['segment'] ?? ($_POST['segment'] ?? 'CLIENT');

    if (!$em) {
        echo json_encode(["status" => "error", "message" => "Missing email parameter"]);
        exit;
    }

    $insert_sql = ($driver === 'sqlite') ? "INSERT OR REPLACE INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING')" : "INSERT INTO clivora_outreach_leads (email, name, company, role, segment, status) VALUES (?, ?, ?, ?, ?, 'PENDING') ON DUPLICATE KEY UPDATE status = 'PENDING'";
    $ins = $pdo->prepare($insert_sql);
    $ins->execute([$em, $nm, $comp, $rl, $seg]);

    echo json_encode(["status" => "success", "message" => "Lead added/re-queued successfully", "email" => $em], JSON_PRETTY_PRINT);
    exit;
}

// Public Status Mode
if (!$is_authorized) {
    echo json_encode([
        "service" => "Clivora & CODCrafters Autonomous Cloud Outreach Engine",
        "status" => "running_in_cloud",
        "active_sender_domain" => "clivora.io (Official Hostinger TLS Mailbox)",
        "cron_schedule" => "Every 3 Hours (Autonomous Hostinger Cron)",
        "today_sent" => $today_sent,
        "max_daily_quota" => $MAX_DAILY_QUOTA,
        "today_remaining" => max(0, $MAX_DAILY_QUOTA - $today_sent),
        "total_sent_lifetime" => $total_sent_lifetime,
        "pending_leads_in_queue" => $pending_leads_count,
        "active_mailboxes" => array_column($CLIVORA_SENDERS, 'from_email'),
        "target_segments" => [
            "CLIENT: Hiring Companies, Agency Founders & CTOs (CODCrafters Software & Clivora OS)",
            "SPONSOR: Tech Partners, Accelerators & Summit 2026 Sponsors",
            "FREELANCER: Independent Developers & Consultants (Zero-Fee OS & 700+ Remote Jobs)"
        ],
        "note" => "Batch, test and lead actions require the operator key."
    ], JSON_PRETTY_PRINT);
    exit;
}

// ─────────────────────────────────────────────────────────────────────────────
// Normal Scheduled Cron Batch Processing
// ─────────────────────────────────────────────────────────────────────────────
if ($today_sent >= $MAX_DAILY_QUOTA) {
    echo json_encode([
        "status" => "capped",
        "message" => "Daily outreach quota of {$MAX_DAILY_QUOTA} emails reached for today.",
        "today_sent" => $today_sent,
        "max_quota" => $MAX_DAILY_QUOTA
    ]);
    exit;
}

// Determine batch size for this execution cycle
$batch_limit = min(5, $MAX_DAILY_QUOTA - $today_sent);
$stmt = $pdo->prepare("SELECT * FROM clivora_outreach_leads WHERE status = 'PENDING' ORDER BY id ASC LIMIT ?");
$stmt->bindValue(1, $batch_limit, PDO::PARAM_INT);
$stmt->execute();
$batch = $stmt->fetchAll();

if (empty($batch)) {
    echo json_encode([
        "status" => "idle",
        "message" => "All scheduled prospects in the campaign directory have already been contacted.",
        "today_sent" => $today_sent,
        "total_sent_lifetime" => $total_sent_lifetime
    ]);
    exit;
}

// Global Rule: Pre-Flight Email Syntax & MX Domain Verification
function verify_email_domain_mx($email, &$reason = "") {
    $email = trim($email);
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $reason = "Invalid email syntax";
        return false;
    }

    $parts = explode('@', $email);
    $domain = end($parts);

    $fake_domains = ['example.com', 'test.com', 'localhost', 'invalid.com', 'tempmail.com'];
    if (in_array(strtolower($domain), $fake_domains, true)) {
        $reason = "Domain is blacklisted or placeholder: {$domain}";
        return false;
    }

    $mx_hosts = [];
    if (function_exists('getmxrr') && getmxrr($domain, $mx_hosts) && !empty($mx_hosts)) {
        return true;
    }

    if (function_exists('checkdnsrr') && checkdnsrr($domain, "MX")) {
        return true;
    }

    if (function_exists('checkdnsrr') && checkdnsrr($domain, "A")) {
        return true;
    }

    // If DNS check functions are disabled or in CLI fallback, do a socket check
    $sock = @fsockopen($domain, 25, $errno, $errstr, 2);
    if ($sock) {
        fclose($sock);
        return true;
    }

    $reason = "Domain {$domain} has no active MX or A mail records";
    return false;
}

$processed = [];
$sender_idx = rand(0, count($CLIVORA_SENDERS) - 1);

foreach ($batch as $lead) {
    // 1. Mandatory Pre-Flight MX Verification Rule
    $reject_reason = "";
    if (!verify_email_domain_mx($lead['email'], $reject_reason)) {
        $upd = $pdo->prepare("UPDATE clivora_outreach_leads SET status = 'REJECTED', response_log = ? WHERE id = ?");
        $upd->execute(["Pre-flight check rejected: {$reject_reason}", $lead['id']]);

        $processed[] = [
            "email" => $lead['email'],
            "name" => $lead['name'],
            "segment" => $lead['segment'],
            "status" => "REJECTED",
            "reason" => $reject_reason
        ];
        continue;
    }

    $sender = $CLIVORA_SENDERS[$sender_idx % count($CLIVORA_SENDERS)];
    $content = generate_outreach_email($lead);

    try {
        send_cloud_smtp($sender, $lead['email'], $content['subject'], $content['html'], $content['plain']);

        $upd = $pdo->prepare("UPDATE clivora_outreach_leads SET status = 'SENT', sent_at = NOW(), response_log = ? WHERE id = ?");
        $upd->execute(["Delivered via {$sender['from_email']} (Hostinger TLS SMTP)", $lead['id']]);

        $processed[] = [
            "email" => $lead['email'],
            "name" => $lead['name'],
            "segment" => $lead['segment'],
            "status" => "SENT",
            "from" => "{$sender['from_name']} <{$sender['from_email']}>"
        ];

        $today_sent++;
        $sender_idx++;

        if (count($batch) > 1) {
            sleep(rand(5, 10));
        }
    } catch (Exception $e) {
        $upd = $pdo->prepare("UPDATE clivora_outreach_leads SET status = 'FAILED', response_log = ? WHERE id = ?");
        $upd->execute([$e->getMessage(), $lead['id']]);

        $processed[] = [
            "email" => $lead['email'],
            "name" => $lead['name'],
            "segment" => $lead['segment'],
            "status" => "FAILED",
            "error" => $e->getMessage()
        ];
    }
}

echo json_encode([
    "status" => "success",
    "cycle_processed" => count($processed),
    "today_total_sent" => $today_sent,
    "max_daily_quota" => $MAX_DAILY_QUOTA,
    "batch_details" => $processed,
    "timestamp" => date('Y-m-d H:i:s')
], JSON_PRETTY_PRINT);

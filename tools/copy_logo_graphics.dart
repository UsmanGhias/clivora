import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final logoPath = 'assets/images/clivora_logo.png';
  final bytes = File(logoPath).readAsBytesSync();
  final logo = img.decodePng(bytes)!;
  final graphics = Directory('play-store/graphics')..createSync(recursive: true);
  File('${graphics.path}/app-icon-512.png').writeAsBytesSync(img.encodePng(img.copyResize(logo, width: 512, height: 512)));
  for (final s in [192, 144, 96, 72, 48]) {
    File('${graphics.path}/app-icon-$s.png').writeAsBytesSync(img.encodePng(img.copyResize(logo, width: s, height: s)));
  }
  // Feature graphic: logo left, text right
  final fg = img.Image(width: 1024, height: 500);
  img.fill(fg, color: img.ColorRgb8(15, 23, 42));
  final icon = img.copyResize(logo, width: 200, height: 200);
  img.compositeImage(fg, icon, dstX: 80, dstY: 150);
  img.drawString(fg, 'CLIVORA', font: img.arial48, x: 320, y: 180, color: img.ColorRgb8(255, 255, 255));
  img.drawString(fg, 'Business OS for Freelancers', font: img.arial24, x: 320, y: 260, color: img.ColorRgb8(20, 184, 166));
  File('${graphics.path}/feature-graphic-1024x500.png').writeAsBytesSync(img.encodePng(fg));
  print('Graphics updated from clivora_logo.png');
}

import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final root = Directory.current;
  final assetsDir = Directory('${root.path}/assets/images');
  final graphicsDir = Directory('${root.path}/play-store/graphics');
  final shotsDir = Directory('${root.path}/play-store/screenshots');
  assetsDir.createSync(recursive: true);
  graphicsDir.createSync(recursive: true);
  shotsDir.createSync(recursive: true);

  final logo = _logo(512);
  File('${assetsDir.path}/clivora_logo.png').writeAsBytesSync(img.encodePng(logo));
  File('${graphicsDir.path}/app-icon-512.png').writeAsBytesSync(img.encodePng(logo));

  for (final s in [192, 144, 96, 72, 48]) {
    File('${graphicsDir.path}/app-icon-$s.png').writeAsBytesSync(img.encodePng(img.copyResize(_logo(s), width: s, height: s)));
  }

  File('${graphicsDir.path}/feature-graphic-1024x500.png').writeAsBytesSync(img.encodePng(_feature()));
  for (var i = 1; i <= 4; i++) {
    File('${shotsDir.path}/screenshot-0$i.png').writeAsBytesSync(img.encodePng(_screenshot(i)));
  }
  stdout.writeln('Store assets generated.');
}

img.Image _logo(int size) {
  final image = img.Image(width: size, height: size);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final t = (x + y) / (size * 2);
      image.setPixelRgb(x, y, _lerp(108, 79, t), _lerp(99, 70, t), _lerp(255, 229, t));
    }
  }
  img.drawString(image, 'C', font: img.arial48, x: size ~/ 3, y: size ~/ 3, color: img.ColorRgb8(255, 255, 255));
  return image;
}

img.Image _feature() {
  final image = img.Image(width: 1024, height: 500);
  for (var y = 0; y < 500; y++) {
    for (var x = 0; x < 1024; x++) {
      final t = y / 499;
      image.setPixelRgb(x, y, _lerp(15, 19, t), _lerp(23, 78, t), _lerp(42, 74, t));
    }
  }
  img.fillRect(image, x1: 60, y1: 120, x2: 200, y2: 380, color: img.ColorRgb8(108, 99, 255), radius: 28);
  img.drawString(image, 'CLIVORA', font: img.arial48, x: 240, y: 160, color: img.ColorRgb8(255, 255, 255));
  img.drawString(image, 'Business OS for Freelancers', font: img.arial24, x: 240, y: 240, color: img.ColorRgb8(148, 163, 184));
  img.drawString(image, 'Clients · Projects · Invoices', font: img.arial24, x: 240, y: 290, color: img.ColorRgb8(20, 184, 166));
  return image;
}

img.Image _screenshot(int n) {
  final titles = ['Dashboard', 'Clients', 'Invoices', 'Workspace'];
  final lines = [
    ['Revenue overview', 'Active projects', 'Quick actions'],
    ['Add clients', 'Contact details', 'Search'],
    ['Create invoices', 'PDF export', 'Track payments'],
    ['Tasks & expenses', 'Reports', 'Pro tools'],
  ];
  final image = img.Image(width: 1080, height: 1920);
  img.fill(image, color: img.ColorRgb8(248, 250, 252));
  img.fillRect(image, x1: 40, y1: 80, x2: 1040, y2: 320, color: img.ColorRgb8(15, 23, 42), radius: 32);
  img.drawString(image, 'CLIVORA — ${titles[n - 1]}', font: img.arial48, x: 80, y: 160, color: img.ColorRgb8(255, 255, 255));
  var y = 400;
  for (final line in lines[n - 1]) {
    img.fillRect(image, x1: 60, y1: y, x2: 1020, y2: y + 120, color: img.ColorRgb8(255, 255, 255), radius: 20);
    img.drawString(image, line, font: img.arial24, x: 100, y: y + 45, color: img.ColorRgb8(15, 23, 42));
    y += 150;
  }
  return image;
}

int _lerp(int a, int b, double t) => (a + (b - a) * t).round();

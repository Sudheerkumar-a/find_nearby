import 'package:find_nearby/core/widgets/whatsapp_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('whatsapp glyph fills the 24px icon box', () {
    final bounds = whatsAppGlyphPath().getBounds();
    expect(bounds.left, greaterThan(-0.1));
    expect(bounds.top, greaterThan(-0.1));
    expect(bounds.right, lessThan(24.1));
    expect(bounds.bottom, lessThan(24.1));
    expect(bounds.width, greaterThan(20));
    expect(bounds.height, greaterThan(20));
  });
}

import 'dart:typed_data';

/// Bitmap class for font file
class TtfBitmap {
  /// Create a TtfBitmap object
  const TtfBitmap(
    this.data,
    this.height,
    this.width,
    this.horizontalBearingX,
    this.horizontalBearingY,
    this.horizontalAdvance,
    this.verticalBearingX,
    this.verticalBearingY,
    this.verticalAdvance,
    this.ascent,
    this.descent,
  );

  /// Uint8List of ttf or otf file
  final Uint8List data;

  /// height of font file
  final int height;

  /// width of font file
  final int width;

  /// horizontalBearingX of font file
  final int horizontalBearingX;

  /// horizontalBearingY of font file
  final int horizontalBearingY;

  /// horizontalAdvance of font file
  final int horizontalAdvance;

  /// verticalBearingX of font file
  final int verticalBearingX;

  /// verticalBearingY of font file
  final int verticalBearingY;

  /// verticalAdvance of font file
  final int verticalAdvance;

  /// ascent of font file
  final int ascent;

  /// descent of font file
  final int descent;

  /// toString function to print property of this class
  @override
  String toString() => "Bitmap Glyph: ${width}x$height"
      "\nhorizontal BearingX:$horizontalBearingX"
      "\nhorizontal BearingY:$horizontalBearingY"
      "\nhorizontal Advance:$horizontalAdvance"
      "\nvertical BearingX:$verticalBearingX"
      "\nvertical BearingY:$verticalBearingY"
      "\nvertical Advance:$verticalAdvance"
      "\nascender:$ascent"
      "\ndescender:$descent";
}

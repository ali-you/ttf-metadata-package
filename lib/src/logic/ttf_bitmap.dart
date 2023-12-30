import 'dart:typed_data';

class TtfBitmap {
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

  final Uint8List data;
  final int height;
  final int width;
  final int horizontalBearingX;
  final int horizontalBearingY;
  final int horizontalAdvance;
  final int verticalBearingX;
  final int verticalBearingY;
  final int verticalAdvance;
  final int ascent;
  final int descent;

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

import '../data/ttf_source.dart';
import 'ttf_parser.dart';

/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfFileSource(path: "path to file"));
/// ```
class TtfMetadata {

  /// Create a TtfMetadata object
  TtfMetadata(this._ttfSource) {
    _ttfParser = _ttfSource.ttfParser;
  }

  /// object of TtfSource that shows type of input source
  final TtfSource _ttfSource;

  /// object of TtfParser
  late final TtfParser _ttfParser;

  /// unitsPerEm of font file
  int get unitsPerEm => _ttfParser.unitsPerEm;

  /// xMin of font file
  int get xMin => _ttfParser.xMin;

  /// yMin of font file
  int get yMin => _ttfParser.yMin;

  /// xMax of font file
  int get xMax => _ttfParser.xMax;

  /// yMax of font file
  int get yMax => _ttfParser.yMax;

  /// indexToLocFormat of font file
  int get indexToLocFormat => _ttfParser.indexToLocFormat;

  /// ascent of font file
  int get ascent => _ttfParser.ascent;

  /// descent of font file
  int get descent => _ttfParser.descent;

  /// lineGap of font file
  int get lineGap => _ttfParser.lineGap;

  /// numOfLongHorMetrics of font file
  int get numOfLongHorMetrics => _ttfParser.numOfLongHorMetrics;

  /// numGlyphs of font file
  int get numGlyphs => _ttfParser.numGlyphs;

  /// fontName of font file
  String get fontName => _ttfParser.fontName;

  /// unicode of font file
  bool get unicode => _ttfParser.unicode;

  /// isBitmap of font file
  bool get isBitmap => _ttfParser.isBitmap;
}

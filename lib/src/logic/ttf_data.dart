import '../data/ttf_source.dart';
import 'ttf_parser.dart';

class TtfMetadata {
  TtfMetadata(this._ttfSource) {
    _ttfParser = _ttfSource.ttfParser;
  }

  final TtfSource _ttfSource;

  late final TtfParser _ttfParser;

  int get unitsPerEm => _ttfParser.unitsPerEm;

  int get xMin => _ttfParser.xMin;

  int get yMin => _ttfParser.yMin;

  int get xMax => _ttfParser.xMax;

  int get yMax => _ttfParser.yMax;

  int get indexToLocFormat => _ttfParser.indexToLocFormat;

  int get ascent => _ttfParser.ascent;

  int get descent => _ttfParser.descent;

  int get lineGap => _ttfParser.lineGap;

  int get numOfLongHorMetrics => _ttfParser.numOfLongHorMetrics;

  int get numGlyphs => _ttfParser.numGlyphs;

  String get fontName => _ttfParser.fontName;

  bool get unicode => _ttfParser.unicode;

  bool get isBitmap => _ttfParser.isBitmap;

  // void _sourceSelector(TtfSource source) {
  //   switch (source.runtimeType) {
  //     case TtfFileSource:
  //       TtfFileSource ttfFileSource = _ttfSource as TtfFileSource;
  //       File ttfFile = File(ttfFileSource.path);
  //       _ttfParser = TtfParser(ttfFile.readAsBytesSync().buffer.asByteData());
  //       break;
  //
  //     default:
  //       throw const FormatException();
  //   }
  // }
}

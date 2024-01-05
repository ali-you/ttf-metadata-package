import 'dart:io';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

/// TtfFileSource extends TtfSource and make file input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfFileSource(path: "path to file"));
/// ```
class TtfFileSource implements TtfSource {
  final String path;

  /// Create a TtfFileSource object
  TtfFileSource({required this.path}) {
    /// get file of this path
    File ttfFile = File(path);

    /// set ttfParser and convert file data (Uint8List) to byte data
    _ttfParser = TtfParser(ttfFile.readAsBytesSync().buffer.asByteData());
  }

  /// object of TtfParser
  late TtfParser _ttfParser;

  /// getter of TtfParser
  @override
  TtfParser get ttfParser => _ttfParser;
}

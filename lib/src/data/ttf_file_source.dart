/// TtfFileSource extends TtfSource and make file input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfFileSource(path: "path to file"));
/// ```

import 'dart:io';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

class TtfFileSource implements TtfSource {
  final String path;

  TtfFileSource({required this.path}) {
    File ttfFile = File(path);
    _ttfParser = TtfParser(ttfFile.readAsBytesSync().buffer.asByteData());
  }

  late TtfParser _ttfParser;

  @override
  TtfParser get ttfParser => _ttfParser;
}

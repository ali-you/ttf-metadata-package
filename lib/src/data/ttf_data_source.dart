/// TtfDataSource extends TtfSource and make byteData (Uint8List) input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfDataSource(byteData: "Uint8List data of .ttf"));
/// ```

import 'dart:typed_data';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

class TtfDataSource implements TtfSource {
  final Uint8List byteData;

  TtfDataSource({required this.byteData}){
    _ttfParser = TtfParser(byteData.buffer.asByteData());
  }

  late TtfParser _ttfParser;

  @override
  TtfParser get ttfParser => _ttfParser;
}

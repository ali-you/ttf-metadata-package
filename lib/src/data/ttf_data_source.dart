import 'dart:typed_data';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

/// TtfDataSource extends TtfSource and make byteData (Uint8List) input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfDataSource(byteData: "Uint8List data of .ttf"));
/// ```
class TtfDataSource implements TtfSource {
  final Uint8List byteData;

  /// Create a TtfDataSource object
  TtfDataSource({required this.byteData}) {
    /// set ttfParser and convert Uint8List to byte data
    _ttfParser = TtfParser(byteData.buffer.asByteData());
  }

  /// object of TtfParser
  late TtfParser _ttfParser;

  /// getter of TtfParser
  @override
  TtfParser get ttfParser => _ttfParser;
}

/// TtfAssetSource extends TtfSource and make .ttf file asset input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfAssetSource(path: "path to asset file"));
/// ```

import 'package:flutter/services.dart';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

class TtfAssetSource extends TtfSource {
  final String path;

  TtfAssetSource({required this.path}) {
    getAsset();
  }

  late TtfParser _ttfParser;

  @override
  TtfParser get ttfParser => _ttfParser;

  Future<void> getAsset() async {
    ByteData assetData = await rootBundle.load(path);
    _ttfParser = TtfParser(assetData);
  }
}

import 'package:flutter/services.dart';

import '../logic/ttf_parser.dart';
import 'ttf_source.dart';

/// TtfAssetSource extends TtfSource and make .ttf file asset input
/// for the ttf_metadata library
/// you can use the package consider the following example:
///
/// ```dart
/// TtfMetadata ttfMetadata = TtfMetadata(TtfAssetSource(path: "path to asset file"));
/// ```
class TtfAssetSource extends TtfSource {
  /// Path of asset source in the project
  final String path;

  /// Create a TtfAssetSource object
  TtfAssetSource({required this.path}) {
    /// cat getAsset() function
    getAsset();
  }

  /// object of TtfParser
  late TtfParser _ttfParser;

  /// getter of TtfParser
  @override
  TtfParser get ttfParser => _ttfParser;

  /// function to get byte data from an asset file
  Future<void> getAsset() async {
    ByteData assetData = await rootBundle.load(path);
    _ttfParser = TtfParser(assetData);
  }
}

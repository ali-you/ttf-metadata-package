import 'package:ttf_metadata/src/logic/ttf_parser.dart';

/// TtfSource is an abstract class to implement inheritance
/// and to have an integration method as input of the package.

abstract class TtfSource {
  TtfParser get ttfParser => throw UnimplementedError();
}

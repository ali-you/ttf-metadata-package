import 'package:ttf_metadata/src/logic/ttf_parser.dart';

/// TtfSource is an abstract class to implement inheritance
/// and to have an integration method as input of the package.
abstract class TtfSource {
  /// getter of TtfParser as an abstract value
  TtfParser get ttfParser => throw UnimplementedError();
}

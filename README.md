# ttf metadata

ttf metadata is a package to get metadata and properties of .ttf and .otf files.


## Features

You can get ttf metadata like:

- fontName
- xMin
- yMin
- xMax
- yMax
- ascent
- descent
- lineGap
- unicode and etc.


## Getting started

To start using the ttf_metadata package, follow these steps:

1. Add the package to your `pubspec.yaml` file:
```
ttf_metadata: ^0.0.3
```

2. Import the package in your Dart code:

dart import 'package:ttf_metadata/ttf_metadata.dart';


## Usage

```dart
TtfMetadata ttfMetadata = TtfMetadata(TtfFileSource(path: "path to file"));
```


## License

This package is released under the MIT License. See the [LICENSE](https://github.com/ali-you/ttf-metadata-package/blob/main/LICENSE) file for more details.
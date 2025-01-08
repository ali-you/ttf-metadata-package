<a href="https://pub.dev/packages/ttf_metadata">
   <img src="https://img.shields.io/pub/v/ttf_metadata?label=pub.dev&labelColor=333940&logo=dart">
</a>
<a href="https://github.com/ali-you/ttf-metadata-package/issues">
   <img alt="Issues" src="https://img.shields.io/github/issues/ali-you/ttf-metadata-package?color=0088ff" />
</a>
<a href="https://github.com/ali-you/ttf-metadata-package/issues?q=is%3Aclosed">
   <img alt="Issues" src="https://img.shields.io/github/issues-closed/ali-you/ttf-metadata-package?color=0088ff" />
</a>
<!-- <a href="https://github.com/ali-you/ambient-light-plugin/pulls">
   <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/ali-you/ambient-light-plugin?color=0088ff" />
</a> -->
<a href="https://github.com/ali-you/ttf-metadata-package/pulls">
   <img alt="GitHub Pull Requests" src="https://badgen.net/github/prs/ali-you/ttf-metadata-package" />
</a>
<a href="https://github.com/ali-you/ttf-metadata-package/blob/main/LICENSE" rel="ugc">
   <img src="https://img.shields.io/github/license/ali-you/ttf-metadata-package?color=#007A88&amp;labelColor=333940;" alt="GitHub">
</a>
<a href="https://github.com/ali-you/ttf-metadata-package">
   <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/ali-you/ttf-metadata-package">
</a>

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
ttf_metadata: ^0.0.6
```

2. Import the package in your Dart code:

dart import 'package:ttf_metadata/ttf_metadata.dart';


## Usage

```dart
TtfMetadata ttfMetadata = TtfMetadata(TtfFileSource(path: "path to file"));
```


## License

This package is released under the MIT License. See the [LICENSE](https://github.com/ali-you/ttf-metadata-package/blob/main/LICENSE) file for more details.

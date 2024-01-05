import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'font_metrics.dart';
import 'ttf_bitmap.dart';
import 'ttf_header.dart';
import 'utils.dart';

/// TtfParser class to parse ttf or otf file and get property of file
class TtfParser {

  /// Create a TtfParser object
  TtfParser(this.bytes) {
    final numTables = bytes.getUint16(4);

    for (var i = 0; i < numTables; i++) {
      final name = utf8.decode(bytes.buffer.asUint8List(i * 16 + 12, 4));
      final offset = bytes.getUint32(i * 16 + 20);
      final size = bytes.getUint32(i * 16 + 24);
      tableOffsets[name] = offset;
      tableSize[name] = size;
    }

    assert(tableOffsets.containsKey(TtfHeader.headTable),
        'Unable to find the `head` table. This file is not a supported TTF font');
    assert(tableOffsets.containsKey(TtfHeader.nameTable),
        'Unable to find the `name` table. This file is not a supported TTF font');
    assert(tableOffsets.containsKey(TtfHeader.hmtxTable),
        'Unable to find the `hmtx` table. This file is not a supported TTF font');
    assert(tableOffsets.containsKey(TtfHeader.hheaTable),
        'Unable to find the `hhea` table. This file is not a supported TTF font');
    assert(tableOffsets.containsKey(TtfHeader.cmapTable),
        'Unable to find the `cmap` table. This file is not a supported TTF font');
    assert(tableOffsets.containsKey(TtfHeader.maxpTable),
        'Unable to find the `maxp` table. This file is not a supported TTF font');

    _parseCMap();
    if (tableOffsets.containsKey(TtfHeader.locaTable) &&
        tableOffsets.containsKey(TtfHeader.glyfTable)) {
      _parseIndexes();
      _parseGlyphs();
    }
    if (tableOffsets.containsKey(TtfHeader.cblcTable) &&
        tableOffsets.containsKey(TtfHeader.cbdtTable)) {
      _parseBitmaps();
    }
  }

  /// bytes of font file
  final ByteData bytes;
  /// offsets of font file table
  final tableOffsets = <String, int>{};
  /// size of font file table
  final tableSize = <String, int>{};

  /// character to glyph index map of font file
  final charToGlyphIndexMap = <int, int>{};
  /// glyph offsets array of font file
  final glyphOffsets = <int>[];
  /// glyph size array of font file
  final glyphSizes = <int>[];
  /// glyph information map of font file
  final glyphInfoMap = <int, FontMetrics>{};
  /// bitmap offsets map of font file
  final bitmapOffsets = <int, TtfBitmap>{};

  /// unitsPerEm of font file
  int get unitsPerEm =>
      bytes.getUint16(tableOffsets[TtfHeader.headTable]! + 18);

  /// xMin of font file
  int get xMin => bytes.getInt16(tableOffsets[TtfHeader.headTable]! + 36);

  /// yMin of font file
  int get yMin => bytes.getInt16(tableOffsets[TtfHeader.headTable]! + 38);

  /// xMax of font file
  int get xMax => bytes.getInt16(tableOffsets[TtfHeader.headTable]! + 40);

  /// yMax of font file
  int get yMax => bytes.getInt16(tableOffsets[TtfHeader.headTable]! + 42);

  /// indexToLocFormat of font file
  int get indexToLocFormat =>
      bytes.getInt16(tableOffsets[TtfHeader.headTable]! + 50);

  /// ascent of font file
  int get ascent => bytes.getInt16(tableOffsets[TtfHeader.hheaTable]! + 4);

  /// descent of font file
  int get descent => bytes.getInt16(tableOffsets[TtfHeader.hheaTable]! + 6);

  /// lineGap of font file
  int get lineGap => bytes.getInt16(tableOffsets[TtfHeader.hheaTable]! + 8);

  /// numOfLongHorMetrics of font file
  int get numOfLongHorMetrics =>
      bytes.getUint16(tableOffsets[TtfHeader.hheaTable]! + 34);

  /// numGlyphs of font file
  int get numGlyphs => bytes.getUint16(tableOffsets[TtfHeader.maxpTable]! + 4);

  /// fontName of font file
  String get fontName =>
      _getNameID(TtfName.postScriptName) ?? hashCode.toString();

  /// unicode of font file
  bool get unicode => bytes.getUint32(0) == 0x10000;

  /// isBitmap of font file
  bool get isBitmap => bitmapOffsets.isNotEmpty && glyphOffsets.isEmpty;

  Utils utils = Utils();

  /// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM06/Chap6name.html
  String? _getNameID(TtfName fontNameID) {
    final basePosition = tableOffsets[TtfHeader.nameTable];
    if (basePosition == null) {
      return null;
    }
    final count = bytes.getUint16(basePosition + 2);
    final stringOffset = bytes.getUint16(basePosition + 4);
    var pos = basePosition + 6;
    String? fontName;

    for (var i = 0; i < count; i++) {
      final platformID = bytes.getUint16(pos);
      final nameID = bytes.getUint16(pos + 6);
      final length = bytes.getUint16(pos + 8);
      final offset = bytes.getUint16(pos + 10);
      pos += 12;

      if (platformID == 1 && nameID == fontNameID.index) {
        try {
          fontName = utf8.decode(bytes.buffer
              .asUint8List(basePosition + stringOffset + offset, length));
        } catch (a) {
          debugPrint('Error: $platformID $nameID $a');
          rethrow;
        }
      }

      if (platformID == 3 && nameID == fontNameID.index) {
        try {
          return _decodeUtf16(bytes.buffer
              .asUint8List(basePosition + stringOffset + offset, length));
        } catch (a) {
          debugPrint('Error: $platformID $nameID $a');
          rethrow;
        }
      }
    }
    return fontName;
  }

  void _parseCMap() {
    final basePosition = tableOffsets[TtfHeader.cmapTable]!;
    final numSubTables = bytes.getUint16(basePosition + 2);
    for (var i = 0; i < numSubTables; i++) {
      final offset = bytes.getUint32(basePosition + i * 8 + 8);
      final format = bytes.getUint16(basePosition + offset);

      switch (format) {
        case 0:
          _parseCMapFormat0(basePosition + offset + 2);
          break;

        case 4:
          _parseCMapFormat4(basePosition + offset + 2);
          break;
        case 6:
          _parseCMapFormat6(basePosition + offset + 2);
          break;

        case 12:
          _parseCMapFormat12(basePosition + offset + 2);
          break;
      }
    }
  }

  void _parseCMapFormat0(int basePosition) {
    assert(bytes.getUint16(basePosition) == 262);
    for (var i = 0; i < 256; i++) {
      final charCode = i;
      final glyphIndex = bytes.getUint8(basePosition + i + 2);
      if (glyphIndex > 0) {
        charToGlyphIndexMap[charCode] = glyphIndex;
      }
    }
  }

  void _parseCMapFormat4(int basePosition) {
    final segCount = bytes.getUint16(basePosition + 4) ~/ 2;
    final endCodes = <int>[];
    for (var i = 0; i < segCount; i++) {
      endCodes.add(bytes.getUint16(basePosition + i * 2 + 12));
    }
    final startCodes = <int>[];
    for (var i = 0; i < segCount; i++) {
      startCodes.add(bytes.getUint16(basePosition + (segCount + i) * 2 + 14));
    }
    final idDeltas = <int>[];
    for (var i = 0; i < segCount; i++) {
      idDeltas.add(bytes.getUint16(basePosition + (segCount * 2 + i) * 2 + 14));
    }
    final idRangeOffsetBasePos = basePosition + segCount * 6 + 14;
    final idRangeOffsets = <int>[];
    for (var i = 0; i < segCount; i++) {
      idRangeOffsets.add(bytes.getUint16(idRangeOffsetBasePos + i * 2));
    }
    for (var s = 0; s < segCount - 1; s++) {
      final startCode = startCodes[s];
      final endCode = endCodes[s];
      final idDelta = idDeltas[s];
      final idRangeOffset = idRangeOffsets[s];
      final idRangeOffsetAddress = idRangeOffsetBasePos + s * 2;
      for (var c = startCode; c <= endCode; c++) {
        int glyphIndex;
        if (idRangeOffset == 0) {
          glyphIndex = (idDelta + c) % 65536;
        } else {
          final glyphIndexAddress =
              idRangeOffset + 2 * (c - startCode) + idRangeOffsetAddress;
          glyphIndex = bytes.getUint16(glyphIndexAddress);
        }
        charToGlyphIndexMap[c] = glyphIndex;

        /// Having both the unicode and the isolated form code
        /// point to the same glyph index because some fonts
        /// do not have a glyph for the isolated form.
        if (utils.basicToIsolatedMappings.containsKey(c)) {
          charToGlyphIndexMap[utils.basicToIsolatedMappings[c]!] = glyphIndex;
        }
      }
    }
  }

  void _parseCMapFormat6(int basePosition) {
    final firstCode = bytes.getUint16(basePosition + 4);
    final entryCount = bytes.getUint16(basePosition + 6);
    for (var i = 0; i < entryCount; i++) {
      final charCode = firstCode + i;
      final glyphIndex = bytes.getUint16(basePosition + i * 2 + 8);
      if (glyphIndex > 0) {
        charToGlyphIndexMap[charCode] = glyphIndex;
      }
    }
  }

  void _parseCMapFormat12(int basePosition) {
    final numGroups = bytes.getUint32(basePosition + 10);
    assert(bytes.getUint32(basePosition + 2) == 12 * numGroups + 16);

    for (var i = 0; i < numGroups; i++) {
      final startCharCode = bytes.getUint32(basePosition + i * 12 + 14);
      final endCharCode = bytes.getUint32(basePosition + i * 12 + 18);
      final startGlyphID = bytes.getUint32(basePosition + i * 12 + 22);

      for (var j = startCharCode; j <= endCharCode; j++) {
        assert(!charToGlyphIndexMap.containsKey(j) ||
            charToGlyphIndexMap[j] == startGlyphID + j - startCharCode);
        charToGlyphIndexMap[j] = startGlyphID + j - startCharCode;
      }
    }
  }

  void _parseIndexes() {
    final basePosition = tableOffsets[TtfHeader.locaTable]!;
    if (indexToLocFormat == 0) {
      var prevOffset = bytes.getUint16(basePosition) * 2;
      for (var i = 1; i < numGlyphs + 1; i++) {
        final offset = bytes.getUint16(basePosition + i * 2) * 2;
        glyphOffsets.add(prevOffset);
        glyphSizes.add(offset - prevOffset);
        prevOffset = offset;
      }
    } else {
      var prevOffset = bytes.getUint32(basePosition);
      for (var i = 1; i < numGlyphs + 1; i++) {
        final offset = bytes.getUint32(basePosition + i * 4);
        glyphOffsets.add(prevOffset);
        glyphSizes.add(offset - prevOffset);
        prevOffset = offset;
      }
    }
  }

  /// https://developer.apple.com/fonts/TrueType-Reference-Manual/RM06/Chap6glyf.html
  void _parseGlyphs() {
    final baseOffset = tableOffsets[TtfHeader.glyfTable]!;
    final hmtxOffset = tableOffsets[TtfHeader.hmtxTable]!;
    final unitsPerEm = this.unitsPerEm;
    final numOfLongHorMetrics = this.numOfLongHorMetrics;
    final defaultAdvanceWidth =
        bytes.getUint16(hmtxOffset + (numOfLongHorMetrics - 1) * 4);

    for (var glyphIndex = 0; glyphIndex < numGlyphs; glyphIndex++) {
      final advanceWidth = glyphIndex < numOfLongHorMetrics
          ? bytes.getUint16(hmtxOffset + glyphIndex * 4)
          : defaultAdvanceWidth;
      final leftBearing = glyphIndex < numOfLongHorMetrics
          ? bytes.getInt16(hmtxOffset + glyphIndex * 4 + 2)
          : bytes.getInt16(hmtxOffset +
              numOfLongHorMetrics * 4 +
              (glyphIndex - numOfLongHorMetrics) * 2);
      if (glyphSizes[glyphIndex] == 0) {
        glyphInfoMap[glyphIndex] = FontMetrics(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          ascent: 0,
          descent: 0,
          advanceWidth: advanceWidth / unitsPerEm,
          leftBearing: leftBearing / unitsPerEm,
        );
        continue;
      }
      final offset = glyphOffsets[glyphIndex];
      final xMin = bytes.getInt16(baseOffset + offset + 2); // 2
      final yMin = bytes.getInt16(baseOffset + offset + 4); // 4
      final xMax = bytes.getInt16(baseOffset + offset + 6); // 6
      final yMax = bytes.getInt16(baseOffset + offset + 8); // 8

      glyphInfoMap[glyphIndex] = FontMetrics(
        left: xMin.toDouble() / unitsPerEm,
        top: yMin.toDouble() / unitsPerEm,
        right: xMax.toDouble() / unitsPerEm,
        bottom: yMax.toDouble() / unitsPerEm,
        ascent: ascent.toDouble() / unitsPerEm,
        descent: descent.toDouble() / unitsPerEm,
        advanceWidth: advanceWidth.toDouble() / unitsPerEm,
        leftBearing: leftBearing.toDouble() / unitsPerEm,
      );
    }
  }

  String _decodeUtf16(Uint8List bytes) {
    final charCodes = <int>[];
    for (var i = 0; i < bytes.length; i += 2) {
      charCodes.add((bytes[i] << 8) | bytes[i + 1]);
    }
    return String.fromCharCodes(charCodes);
  }

  // https://docs.microsoft.com/en-us/typography/opentype/spec/ebdt
  void _parseBitmaps() {
    final baseOffset = tableOffsets[TtfHeader.cblcTable]!;
    final pngOffset = tableOffsets[TtfHeader.cbdtTable]!;

    // CBLC Header
    final numSizes = bytes.getUint32(baseOffset + 4);
    var bitmapSize = baseOffset + 8;

    for (var bitmapSizeIndex = 0;
        bitmapSizeIndex < numSizes;
        bitmapSizeIndex++) {
      // BitmapSize Record
      final indexSubTableArrayOffset = baseOffset + bytes.getUint32(bitmapSize);
      // final indexTablesSize = bytes.getUint32(bitmapSize + 4);
      final numberOfIndexSubTables = bytes.getUint32(bitmapSize + 8);

      final ascender = bytes.getInt8(bitmapSize + 12);
      final descender = bytes.getInt8(bitmapSize + 13);

      // final startGlyphIndex = bytes.getUint16(bitmapSize + 16 + 12 * 2);
      // final endGlyphIndex = bytes.getUint16(bitmapSize + 16 + 12 * 2 + 2);
      // final ppemX = bytes.getUint8(bitmapSize + 16 + 12 * 2 + 4);
      // final ppemY = bytes.getUint8(bitmapSize + 16 + 12 * 2 + 5);
      // final bitDepth = bytes.getUint8(bitmapSize + 16 + 12 * 2 + 6);
      // final flags = bytes.getUint8(bitmapSize + 16 + 12 * 2 + 7);

      var subTableArrayOffset = indexSubTableArrayOffset;
      for (var indexSubTable = 0;
          indexSubTable < numberOfIndexSubTables;
          indexSubTable++) {
        // IndexSubTableArray
        final firstGlyphIndex = bytes.getUint16(subTableArrayOffset);
        final lastGlyphIndex = bytes.getUint16(subTableArrayOffset + 2);
        final additionalOffsetToIndexSubtable =
            indexSubTableArrayOffset + bytes.getUint32(subTableArrayOffset + 4);

        // IndexSubHeader
        final indexFormat = bytes.getUint16(additionalOffsetToIndexSubtable);
        final imageFormat =
            bytes.getUint16(additionalOffsetToIndexSubtable + 2);
        final imageDataOffset =
            pngOffset + bytes.getUint32(additionalOffsetToIndexSubtable + 4);

        if (indexFormat == 1) {
          // IndexSubTable1

          for (var glyph = firstGlyphIndex; glyph <= lastGlyphIndex; glyph++) {
            final sbitOffset = imageDataOffset +
                bytes.getUint32(additionalOffsetToIndexSubtable +
                    (glyph - firstGlyphIndex + 2) * 4);

            if (imageFormat == 17) {
              final height = bytes.getUint8(sbitOffset);
              final width = bytes.getUint8(sbitOffset + 1);
              final bearingX = bytes.getInt8(sbitOffset + 2);
              final bearingY = bytes.getInt8(sbitOffset + 3);
              final advance = bytes.getUint8(sbitOffset + 4);
              final dataLen = bytes.getUint32(sbitOffset + 5);

              bitmapOffsets[glyph] = TtfBitmap(
                  bytes.buffer.asUint8List(
                    bytes.offsetInBytes + sbitOffset + 9,
                    dataLen,
                  ),
                  height,
                  width,
                  bearingX,
                  bearingY,
                  advance,
                  0,
                  0,
                  0,
                  ascender,
                  descender);
            }
          }
        }

        subTableArrayOffset += 8;
      }
      bitmapSize += 16 + 12 * 2 + 8;
    }
  }
}

enum TtfName {
  copyright,
  fontFamily,
  fontSubfamily,
  uniqueID,
  fullName,
  version,
  postScriptName,
  trademark,
  manufacturer,
  designer,
  description,
  manufacturerURL,
  designerURL,
  license,
  licenseURL,
  reserved,
  preferredFamily,
  preferredSubfamily,
  compatibleFullName,
  sampleText,
  postScriptFindFontName,
  wwsFamily,
  wwsSubfamily,
}

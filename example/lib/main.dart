import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ttf_metadata/ttf_metadata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fontInfo = 'File Not Imported';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ttf_metadata example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(type: FileType.any);
                  if (result != null) {
                    if (kIsWeb) {
                      TtfMetadata ttfMetadata = TtfMetadata(
                          TtfDataSource(byteData: result.files.single.bytes!));
                      _fontInfo = ttfMetadata.toString();
                      setState(() {});
                    } else {
                      File file = File(result.files.single.path!);
                      String extension =
                          (file.path.split('.').last).toLowerCase();
                      if (extension == 'ttf' || extension == 'otf') {
                        if (mounted) {
                          TtfMetadata ttfMetadata =
                              TtfMetadata(TtfFileSource(path: file.path));
                          _fontInfo = ttfMetadata.toString();
                          setState(() {});
                        }
                      }
                    }
                  }
                },
                child: const Text("Select font file"),
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    "Font Metadata:\n\n$_fontInfo",
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

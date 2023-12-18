import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

Future<void> uploadFile(File file) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('YOUR_API_ENDPOINT'),
  );

  // Add file to the request
  var stream = http.ByteStream.fromBytes(await file.readAsBytes());
  var length = await file.length();
  var multipartFile = http.MultipartFile(
    'file',
    stream,
    length,
    filename: basename(file.path),
    contentType: MediaType.parse(lookupMimeType(file.path) ?? 'application/octet-stream'),
  );

  request.files.add(multipartFile);

  // Add any additional headers or parameters if needed
  // request.headers.addAll({'key': 'value'});
  // request.fields.addAll({'key': 'value'});

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status ${response.statusCode}');
    }
  } catch (e) {
    print('Error during file upload: $e');
  }
}

Future<void> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['txt', 'html'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    await uploadFile(file);
  } else {
    // User canceled the file picking
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('File Upload Example'),
        ),
        body: const Center(
          child: ElevatedButton(
            onPressed: pickFile,
            child: Text('Pick and Upload File'),
          ),
        ),
      ),
    ),
  );
}

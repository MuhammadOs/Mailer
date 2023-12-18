import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomUploadRow extends StatefulWidget {
  CustomUploadRow({
    Key? key,
    required this.text,
    required this.onFilePicked, // Add this callback
  }) : super(key: key);

  final String text;
  final void Function(File pickedFile) onFilePicked; // Callback function

  @override
  State<CustomUploadRow> createState() => _CustomUploadRowState();
}

class _CustomUploadRowState extends State<CustomUploadRow> {
  late File _pickedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File pickedFile = File(result.files.single.path!);

      // Check the file type here (for example, allow only text files)
      if (!pickedFile.path.toLowerCase().endsWith('.txt')) {
        // Show an error message for invalid file type
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid file type. Please select a text file.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      setState(() {
        _pickedFile = pickedFile;
        print('File picked: ${_pickedFile.path}');

        // Call the callback function to return the picked file
        widget.onFilePicked(_pickedFile);
      });
    } else {
      print('No file picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomContainer(
            color: const Color(0xff005599),
            text: widget.text,
          ),
          const SizedBox(
            width: 40,
          ),
          DottedBorder(
            color: const Color(0xff005599),
            strokeWidth: 2,
            dashPattern: const [5, 5],
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: pickFile,
                  icon: const Icon(
                    Icons.upload_file_rounded,
                    size: 50.0,
                    color: Color(0xff005599),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

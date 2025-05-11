import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/providers/kb_provider.dart';
import 'package:provider/provider.dart';

class LocalFileUploadDialog extends StatefulWidget {
  final String knowledgeBaseId;

  const LocalFileUploadDialog({Key? key, required this.knowledgeBaseId}) : super(key: key);

  @override
  _LocalFileUploadDialogState createState() => _LocalFileUploadDialogState();
}

class _LocalFileUploadDialogState extends State<LocalFileUploadDialog> {
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'c', 'cpp', 'docx', 'html', 'java', 'json', 'md', 'pdf',
        'php', 'pptx', 'py', 'rb', 'tex', 'txt'
      ],
      // Allow bytes to be read on web
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _importFile() async {
    if (_pickedFile == null) return;

    final provider = Provider.of<KnowledgeBaseProvider>(context, listen: false);

    try {
      String fileId;
      if (kIsWeb) {
        if (_pickedFile!.bytes == null) {
          throw Exception('File bytes are unavailable on web');
        }
        fileId = await provider.importLocalFile(
          fileName: _pickedFile!.name,
          fileBytes: _pickedFile!.bytes!,
        );
      } else {
        // On non-web, use path
        if (_pickedFile!.path == null) {
          throw Exception('File path is unavailable on non-web platform');
        }
        fileId = await provider.importLocalFile(
          filePath: _pickedFile!.path!,
        );
      }

      await provider.linkFileToKnowledgeBase(
        knowledgeBaseId: widget.knowledgeBaseId,
        fileId: fileId,
        fileName: _pickedFile!.name,
      );
      print('File linked successfully');
      await provider.fetchKnowledgeUnits(widget.knowledgeBaseId);
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload and linking completed!')),
      );
    } catch (e, stackTrace) {
      print('Error during file upload or linking: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload or link file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUploading = Provider.of<KnowledgeBaseProvider>(context).isUploading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Upload Local File",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Choose File"),
              style: ElevatedButton.styleFrom(backgroundColor: jvGrey, foregroundColor: jvBlue),
            ),
            const SizedBox(height: 20),
            if (_pickedFile != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: jvGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: jvBlue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: jvDeepBlue, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pickedFile!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (isUploading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  GradientElevatedButton(
                    onPressed: _importFile,
                    text: 'Import',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
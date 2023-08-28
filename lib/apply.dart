import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class ApplyPage extends StatefulWidget {
  final String jobId;

  ApplyPage({required this.jobId, required this.context});
  final BuildContext context;

  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String coverLetter;
  File? resumeFile;
  bool isUploading = false;

  Future<void> _applyJob() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isUploading = true;
      });

      try {
        // Upload the resume file
        String resumeUrl = '';
        if (resumeFile != null) {
          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              resumeFile!.path,
              filename: basename(resumeFile!.path),
            ),
          });

          final response = await Dio().post(
            'http://192.168.42.10:5000/upload',
            data: formData,
          );

          if (response.statusCode == 200) {
            resumeUrl = response.data['fileUrl'];
          } else {
            throw Exception('Failed to upload resume file');
          }
        }

        // Send the application details to the API
        final applicationData = {
          'job': widget.jobId,
          'letter': coverLetter,
          'resume': resumeUrl,
        };

        final response = await Dio().post(
          'http://192.168.42.10:5000/apply',
          data: applicationData,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            widget.context,
            MaterialPageRoute(
              builder: (context) => ApplySuccessPage(),
            ),
          );

          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(
              content: Text('Application submitted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception('Failed to submit application');
        }
      } catch (e) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application'),
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  void selectFile() async {
    File? pickedFile = await pickPdfFile();
    if (pickedFile != null) {
      // File picked successfully
      // You can now proceed with uploading or processing the file
    } else {
      // No valid PDF file selected
      // Handle the case where the user did not select a PDF file
    }
  }

  Future<File?> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      if (file.extension == 'pdf') {
        File pickedFile = File(file.path!);
        return pickedFile;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job ID: ${widget.jobId}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cover Letter',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a cover letter';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    coverLetter = value!;
                  },
                ),
                SizedBox(height: 16.0),
                Text('Resume'),
                resumeFile != null
                    ? Text(basename(resumeFile!.path))
                    : Container(),
                ElevatedButton(
                  onPressed: pickPdfFile,
                  child: Text('Select Resume'),
                ),
                SizedBox(height: 16.0),
                isUploading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _applyJob,
                        child: Text('Submit Application'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplySuccessPage extends StatelessWidget {
  const ApplySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Success"),
      ),
    );
  }
}

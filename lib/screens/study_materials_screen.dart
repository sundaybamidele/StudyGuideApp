import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Materials'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: storageService.listFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final files = snapshot.data;
            return ListView.builder(
              itemCount: files?.length ?? 0,
              itemBuilder: (context, index) {
                final file = files?[index];
                return ListTile(
                  title: Text(file?['name'] ?? ''),
                  onTap: () async {
                    final fileName = file?['name'] ?? '';
                    final fileUrl = file?['url'] ?? '';

                    // Try to download and open the file
                    final localPath = await storageService.downloadFile(fileName);
                    if (localPath != null) {
                      final fileUri = Uri.file(localPath);
                      if (await canLaunch(fileUri.toString())) {
                        await launch(fileUri.toString());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open the file.')),
                        );
                      }
                    } else {
                      // If downloading fails, try to open the file directly via URL
                      if (await canLaunch(fileUrl)) {
                        await launch(fileUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open the file.')),
                        );
                      }
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No files found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            await storageService.uploadFile(result.files.first);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import 'package:file_picker/file_picker.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the StorageService provider
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
                return ListTile(
                  title: Text(files?[index]['name'] ?? ''),
                  onTap: () {
                    storageService.downloadFile(files?[index]['name'] ?? '');
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

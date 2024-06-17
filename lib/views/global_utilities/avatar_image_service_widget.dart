import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/file/file_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/file_view_model.dart';

class CircleAvatarImageService extends StatelessWidget {
  final String filename;

  CircleAvatarImageService({required this.filename});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FileViewModel(
        FileService(),
        SecureStorageHelper(),
      )..fetchFile(filename),
      child: Consumer<FileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (viewModel.hasError || viewModel.fileData == null) {
            return Container(
              child: Center(child: Icon(Icons.error)),
            );
          } else {
            return CircleAvatar(
              backgroundImage: MemoryImage(viewModel.fileData!)               
            );
          }
        },
      ),
    );
  }
}

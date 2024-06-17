import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/file/file_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/file_view_model.dart';

class ContainerImageService extends StatefulWidget {
  final String filename;
  final double sizeImage; 

  ContainerImageService({required this.filename, required this.sizeImage});

  @override
  State<ContainerImageService> createState() => _ContainerImageServiceState();
}

class _ContainerImageServiceState extends State<ContainerImageService> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FileViewModel(
        FileService(),
        SecureStorageHelper(),
      )..fetchFile(widget.filename),
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
            return Container(
              height: widget.sizeImage,
              width: widget.sizeImage,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: MemoryImage(viewModel.fileData!), fit: BoxFit.cover)
              ) 
            );
          }
        },
      ),
    );
  }
}

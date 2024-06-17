import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/file/file_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/file_view_model.dart';

class GameImageService extends StatefulWidget {
  final String filename;
  final double sizeImage; 

  GameImageService({required this.filename, required this.sizeImage});

  @override
  State<GameImageService> createState() => _GameImageServiceState();
}

class _GameImageServiceState extends State<GameImageService> {
  late FileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FileViewModel(FileService(), SecureStorageHelper());
    _viewModel.fetchFile(widget.filename);
  }

  @override
  void didUpdateWidget(GameImageService oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filename != widget.filename) {
      _viewModel.fetchFile(widget.filename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
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
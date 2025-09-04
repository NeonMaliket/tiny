import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:tiny/bloc/storage_bloc/storage_bloc.dart';
import 'package:tiny/domain/domain.dart';

class DocPreview extends StatefulWidget {
  const DocPreview({super.key, required this.metadata});

  final DocumentMetadata metadata;

  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  @override
  void didChangeDependencies() {
    context.read<StorageBloc>().add(
      DownloadDocumentEvent(metadata: widget.metadata),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageBloc, StorageState>(
      builder: (context, StorageState state) {
        if (state is StorageDocumentDownloading) {
          return CircularProgressIndicator();
        } else if (state is StorageDocumentDownloaded) {
          return FileReaderView(
            filePath: state.filePath,
            unSupportFileWidget: Center(child: Text('Unsupported file type')),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

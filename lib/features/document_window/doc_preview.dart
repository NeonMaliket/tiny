import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:tiny/bloc/storage_cubit/storage_cubit.dart';
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
    context.read<StorageCubit>().downloadDocument(widget.metadata);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageCubit, StorageState>(
      builder: (context, StorageState state) {
        if (state is StorageDocumentDownloading) {
          return CircularProgressIndicator();
        } else if (state is StorageDocumentDownloaded) {
          return PDFView(
            pdfData: state.file,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

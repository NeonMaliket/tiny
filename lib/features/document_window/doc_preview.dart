import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';

class DocPreview extends StatefulWidget {
  const DocPreview({super.key, required this.path});

  final String path;

  @override
  State<DocPreview> createState() => _DocPreviewState();
}

class _DocPreviewState extends State<DocPreview> {
  @override
  void initState() {
    super.initState();
    context.read<StorageCubit>().downloadStorageFile(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageCubit, StorageState>(
      builder: (context, state) {
        if (state is GlobalStorageHandling) {
          return const Center(child: LoaderWidget());
        }

        if (state is StorageDownloadSuccess) {
          return FileReaderView(
            filePath: state.file.path,
            unSupportFileWidget: const Center(
              child: Text('Unsupported file type'),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/storage_cubit/storage_cubit.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart' as utils;
import 'package:tiny/utils/utils.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final documents = [];

  late final StreamSubscription<Event> _storageSubscription;

  @override
  void didChangeDependencies() {
    setState(() {
      _storageSubscription = context
          .read<StorageCubit>()
          .streamStorage()
          .listen(_onStorageLoaded);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _storageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return documents.isEmpty
        ? Center(child: Text('No documents found'))
        : GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisCount: 2,
            children: documents
                .map((document) => DocumentItem(metadata: document))
                .toList(),
          );
  }

  void _onStorageLoaded(Event event) {
    final streamEvent = StreamEventType.fromString(
      event.event,
    ).build(event.data);

    switch (streamEvent.event) {
      case StreamEventType.newInstance:
      case StreamEventType.history:
        if (event.data != null) {
          final metadata = DocumentMetadata.fromJson(streamEvent.data!);
          documents.add(metadata);
        }
      case StreamEventType.delete:
        if (event.data != null) {
          final data = json.decode(event.data!) as Map<String, dynamic>;
          documents.removeWhere((doc) => doc.id == data['id']);
        }
      default:
        return;
    }
    setState(() {});
  }
}

class DocumentItem extends StatelessWidget {
  const DocumentItem({super.key, required this.metadata});

  final DocumentMetadata metadata;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onDoubleTap: () {
          context.read<StorageCubit>().deleteDocument(metadata);
        },
        splashColor: context.theme().colorScheme.secondary.withAlpha(60),
        onTap: () {
          logger.i('Selected Document: $metadata');
          context.push('/document', extra: metadata);
        },
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: utils.buildAssetImage(metadata),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: metadata.filename,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                color: context.theme().colorScheme.secondary.withAlpha(60),
                alignment: Alignment.center,
                child: Text(
                  metadata.filename,
                  style: context.theme().textTheme.bodyLarge?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

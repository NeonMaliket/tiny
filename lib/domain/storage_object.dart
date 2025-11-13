import 'package:equatable/equatable.dart';

class StorageObject with EquatableMixin {
  final String id;
  final String name;
  final String bucketId;

  StorageObject({
    required this.id,
    required this.name,
    required this.bucketId,
  });

  String get fullPath => '$bucketId/$name';
  String get filename => name.split('/').last;

  factory StorageObject.fromMap(Map<String, dynamic> map) {
    return StorageObject(
      id: map['id'] as String,
      name: map['name'] as String,
      bucketId: map['bucket_id'] as String,
    );
  }

  @override
  String toString() {
    return 'StorageObject(id: $id, name: $name, bucketId: $bucketId)';
  }

  @override
  List<Object> get props => [id, name, bucketId];
}

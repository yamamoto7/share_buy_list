import 'package:intl/intl.dart';

final DateFormat _outputFormat = DateFormat('yyyy-MM-dd HH:mm');

class GoodsItemData {
  GoodsItemData(
      {required this.id,
      this.title = '',
      this.description = '',
      this.isFinished = false,
      this.isDirectory = false,
      this.updatedAt = '',
      this.createdAt = '',
      this.updatedBy = ''});

  factory GoodsItemData.fromJson(dynamic parsedJson) {
    return GoodsItemData(
        id: parsedJson['id'] as String,
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String,
        isFinished: parsedJson['is_finished'] as bool,
        isDirectory: parsedJson['is_directory'] as bool,
        updatedAt: _outputFormat.format(
            DateTime.parse(parsedJson['updated_at'] as String).toLocal()),
        createdAt: _outputFormat.format(
            DateTime.parse(parsedJson['created_at'] as String).toLocal()),
        updatedBy: parsedJson['last_updated_user']['name'] as String);
  }

  String id;
  String title;
  String description;
  bool isFinished;
  bool isDirectory;
  String updatedAt;
  String createdAt;
  String updatedBy;
}

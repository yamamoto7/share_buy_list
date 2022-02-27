import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

final DateFormat _outputFormat = DateFormat('yyyy-MM-dd HH:mm');

class GoodsItemData {
  BigInt id;
  String title;
  String description;
  bool isFinished;
  bool isDirectory;
  String updatedAt;
  String createdAt;
  String updatedBy;

  GoodsItemData(
      {required this.id,
      this.title = '',
      this.description = '',
      this.isFinished = false,
      this.isDirectory = false,
      this.updatedAt = '',
      this.createdAt = '',
      this.updatedBy = ''});

  factory GoodsItemData.fromJson(Map<dynamic, dynamic> parsedJson) {
    if (!parsedJson.containsKey('id') ||
        !parsedJson.containsKey('title') ||
        !parsedJson.containsKey('is_finished') ||
        !parsedJson.containsKey('is_directory')) {
      return GoodsItemData(id: BigInt.from(-1));
    }
    return GoodsItemData(
        id: BigInt.from(parsedJson['id']),
        title: parsedJson['title'],
        description: parsedJson['description'],
        isFinished: parsedJson['is_finished'],
        isDirectory: parsedJson['is_directory'],
        updatedAt: DateFormat('yyyy-MM-dd HH:mm')
            .format(DateTime.parse(parsedJson['updated_at']).toLocal()),
        createdAt: DateFormat('yyyy-MM-dd HH:mm')
            .format(DateTime.parse(parsedJson['created_at']).toLocal()),
        updatedBy: parsedJson['updated_user']['name']);
  }
}

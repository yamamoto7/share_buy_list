// final DateFormat _outputFormat = DateFormat('yyyy-MM-dd HH:mm');

class GoodsItemData {
  GoodsItemData(
      {required this.id,
      this.title = '',
      this.description = '',
      this.isFinished = false,
      this.isDirectory = false,
      this.updatedAt = '',
      this.createdAt = '',
      this.updatedBy = '',
      this.displayOrder = 0,
      this.isDeleted = false,
      this.uploaded = true});

  GoodsItemData.fromMap(Map<String, dynamic> map) {
    id = map['id'] as String;
    title = map['title'] as String;
    description = map['description'] as String;
    isFinished = map['is_finished'] as int == 1;
    isDirectory = map['is_directory'] as int == 1;
    updatedAt = map['updated_at'] as String;
    createdAt = map['created_at'] as String;
    updatedBy = map['last_updated_user_id'] as String;
    displayOrder =
        map['display_order'] == null ? -2 : map['display_order'] as int;
    isDeleted = map['is_deleted'] as int == 1;
    uploaded = map['uploaded'] as int == 1;
  }

  factory GoodsItemData.fromJson(dynamic parsedJson) {
    return GoodsItemData(
        id: parsedJson['id'] as String,
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String,
        isFinished: parsedJson['is_finished'] as bool,
        isDirectory: parsedJson['is_directory'] as bool,
        updatedAt: parsedJson['updated_at'] as String,
        createdAt: parsedJson['created_at'] as String,
        updatedBy: parsedJson['last_updated_user']['name'] as String,
        displayOrder: parsedJson['display_order'] == null
            ? -1
            : parsedJson['display_order'] as int,
        isDeleted: parsedJson['is_deleted'] as bool,
        uploaded: parsedJson['uploaded'] != 0);
  }

  Map<String, dynamic> toMap(String goodsItemID) {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'is_finished': isFinished ? 1 : 0,
      'is_directory': isDirectory ? 1 : 0,
      'goods_item_id': goodsItemID,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'last_updated_user_id': updatedBy,
      'display_order': displayOrder,
      'is_deleted': isDeleted ? 1 : 0,
      'uploaded': uploaded ? 1 : 0
    };
  }

  void setData(GoodsItemData goodsItemData) {
    id = goodsItemData.id;
    title = goodsItemData.title;
    description = goodsItemData.description;
    isFinished = goodsItemData.isFinished;
    isDirectory = goodsItemData.isDirectory;
    updatedAt = goodsItemData.updatedAt;
    createdAt = goodsItemData.createdAt;
    updatedBy = goodsItemData.updatedBy;
    // displayOrder = goodsItemData.displayOrder;
    isDeleted = goodsItemData.isDeleted;
  }

  @override
  String toString() {
    return 'GoodsItem{id: $id, title: $title, description: $description, is_finished: $isFinished, is_directory: $isDirectory, created_at: $createdAt, updated_at: $updatedAt, updated_by: $updatedBy, display_order: $displayOrder, is_deleted: $isDeleted}';
  }

  late String id;
  late String title;
  late String description;
  late bool isFinished;
  late bool isDirectory;
  late String updatedAt;
  late String createdAt;
  late String updatedBy;
  late int displayOrder;
  late bool isDeleted;
  late bool uploaded;
}

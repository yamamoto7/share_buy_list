// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:sqflite/sqflite.dart';

// ignore: avoid_classes_with_only_static_members
class SqlObject {
  static late Database db;
  static Future<void> initSql() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'share_buy_list_database.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE IF NOT EXISTS goods_items(
            id TEXT PRIMARY KEY,
            display_order INTEGER,
            title TEXT,
            description TEXT,
            created_at TEXT,
            updated_at TEXT,
            last_updated_user_id TEXT,
            is_directory INTEGER DEFAULT 0,
            goods_item_id TEXT,
            is_finished INTEGER DEFAULT 0,
            uploaded INTEGER DEFAULT 1,
            is_deleted INTEGER DEFAULT 0
            );
          ''');
      },
      version: 1,
    );
  }

  static Future<int> removeGoodsItem(String goodsItemID) async {
    final result = await db.rawDelete("""
        DELETE FROM goods_items
        WHERE id = '$goodsItemID';
      """);

    return result;
  }

  static Future<List<GoodsItemData>> getGoodsGroupItems(
      String goodsItemID) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
        SELECT * FROM goods_items
        WHERE goods_item_id = '$goodsItemID'
        AND is_deleted = 0;
      """);

    return List.generate(maps.length, (i) {
      return GoodsItemData.fromMap(maps[i]);
    });
  }

  static Future<List<GoodsItemData>> getGoodsItems(String goodsItemID) async {
    await reorderGoodsItems(goodsItemID);
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
        SELECT * FROM goods_items
        WHERE goods_item_id = '$goodsItemID'
        AND is_deleted = 0
        ORDER BY display_order, created_at ASC, id ASC;
      """);

    return List.generate(maps.length, (i) {
      return GoodsItemData.fromMap(maps[i]);
    });
  }

  static Future<void> reorderGoodsItems(String goodsItemID) async {
    await db.rawUpdate("""
        UPDATE goods_items AS m
        SET display_order = (
          SELECT new_display_order * 10
          FROM (
            SELECT ROW_NUMBER() OVER (
              ORDER BY display_order, created_at ASC, id ASC
            ) AS new_display_order, id
            FROM goods_items
            WHERE goods_item_id = '$goodsItemID'
            AND is_deleted = 0
          )
          WHERE id = m.id
        )
        WHERE goods_item_id = '$goodsItemID'
        AND is_deleted = 0;
      """);
  }

  static Future<int> insertOrUpdateGoodsItem(
      GoodsItemData goodsItemData, String goodsItemID) async {
    if (goodsItemData.displayOrder < 0) {
      final displayOrder = await db.rawQuery("""
        SELECT display_order FROM goods_items
        WHERE goods_item_id = '$goodsItemID'
        ORDER BY display_order DESC
        LIMIT 1;
      """);
      goodsItemData.displayOrder = displayOrder.isNotEmpty
          ? (displayOrder[0]['display_order']! as int) + 1
          : 0;
    }

    final result = await db.insert(
        'goods_items', goodsItemData.toMap(goodsItemID),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  static Future<void> insertOrUpdateGoodsItemList(
      List<GoodsItemData> goodsItemDataList, String goodsItemID) async {
    for (var i = 0; i < goodsItemDataList.length; i++) {
      await insertOrUpdateGoodsItem(goodsItemDataList[i], goodsItemID);
    }
  }

  static Future<void> updateGoodsItemOrder(
      GoodsItemData goodsItemData, String goodsItemID) async {
    await db.rawUpdate("""
        UPDATE goods_items
        SET display_order = ${goodsItemData.displayOrder}
        WHERE id = '${goodsItemData.id}';
      """);
    await reorderGoodsItems(goodsItemID);
  }
}

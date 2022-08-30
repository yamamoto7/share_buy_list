import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:intl/intl.dart';

class GraphQlObject {
  static const _token = GRAPHQL_TOKEN;
  static AuthLink authLink = AuthLink(
    headerKey: 'x-hasura-admin-secret',
    getToken: () async => _token,
  );

  static HttpLink httpLink = HttpLink(GRAPHQL_HOST_HTTP);
  // static Link link = httpLink as Link;
  static final WebSocketLink websocketLink = WebSocketLink(
    GRAPHQL_HOST_WS,
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        return {
          'headers': {'x-hasura-admin-secret': _token},
        };
      },
    ),
  );
  static Link link = authLink.concat(websocketLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    ),
  );

  Future<QueryResult<dynamic>> query(String query) async {
    final result = await client.value.query<dynamic>(QueryOptions<dynamic>(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache,
    ));

    if (result.hasException) {
      // エラー処理
      print(result.exception);
      for (final error in result.exception!.graphqlErrors) {
        print(error.message);
      }
    }

    return result;
  }
}

GraphQlObject graphQlObject = GraphQlObject();

String addNewUser(String name, int iconId) {
  return '''
    mutation {
      insert_user(objects: {name: "$name", icon_id: $iconId}) {
        returning {
          id
          name
          icon_id
        }
      }
    }
  ''';
}

String fetchUserGoodsItems(String userId) {
  return '''
query fetchUserGoodsItems {
  user_goods_item (where: {user_id: {_eq: "$userId"}}) {
    id
    goods_item {
      id
      is_finished
      is_directory
      title
      description
      created_at
      updated_at
      goods_item_id
      is_deleted
      last_updated_user_id
      last_updated_user {
        id
        name
        icon_id
      }
      user_goods_items {
        id
        user {
          id
          name
          icon_id
        }
      }
    }
  }
}
  ''';
}

String addGoodsGroupItem = '''
  mutation AddTask (\$title: String, \$description: String, \$user_id: uuid) {
    insert_goods_item(
      objects: {
        title: \$title,
        last_updated_user_id: \$user_id,
        description: \$description,
        user_goods_items: {data: {user_id: \$user_id}}
      }
    ) {
      returning {
        id
        goods_item_id
      }
    }
  }
''';

String addGoodsItem = '''
  mutation AddGoodsItem (\$title: String, \$description: String, \$goods_item_id: uuid, \$is_directory: Boolean, \$user_id: uuid) {
    insert_goods_item(
      objects: {
        title: \$title,
        description: \$description,
        goods_item_id: \$goods_item_id,
        last_updated_user_id: \$user_id,
        is_directory: \$is_directory
      }
    ) {
      returning {
        id
        is_finished
        is_directory
        title
        description
        created_at
        updated_at
        is_deleted
      }
    }
  }
''';

String toggleGoodsItemQuery(String goodsItemID, bool isFinished) {
  return '''
mutation ToggleGoodsItem {
  update_goods_item_by_pk(pk_columns: {id: "$goodsItemID"}, _set: {is_finished: $isFinished}) {
    updated_at
  }
}
''';
}

String updateGoodsItemData = '''
mutation UpdateGoodsItemData (\$id: uuid!, \$user_id: uuid, \$title: String, \$description: String) {
  update_goods_item_by_pk(
    pk_columns: {id: \$id}, _set: {last_updated_user_id: \$user_id, title: \$title, description: \$description}) {
      id
      is_finished
      is_directory
      title
      description
      created_at
      updated_at
  }
}
''';

String updateGoodsGroup = '''
  mutation UpdateGoodsItem (\$id: bigint!, \$user_id: uuid, \$title: String, \$description: String) {
    update_goods_item_by_pk(
      pk_columns: {id: \$id}, _set: {last_updated_user_id: \$user_id, title: \$title, description: \$description}) {
        id
        is_finished
        is_directory
        title
        description
        created_at
        updated_at
    }
  }
''';

String deleteGoodsItem(String goodsItemID) {
  return '''
mutation DeleteGoodsItem {
  delete_goods_item_by_pk(id: "$goodsItemID") {
    id
  }
}
''';
}

String deleteGoodsGroup(String userGoodsItemID) {
  return '''
mutation DeleteUserGoodsItem {
  delete_user_goods_item_by_pk(id: "$userGoodsItemID") {
    id
  }
}
''';
}

String fetchGoodsItems(
    String goodsItemID, String lastUpdatedAt, String userID) {
  return '''
subscription fetchGoodsItem {
  goods_item(order_by: {updated_at: asc, is_directory: desc, id: desc}, where: {goods_item_id: {_eq: "$goodsItemID"}, updated_at: {_gt: "$lastUpdatedAt"}, last_updated_user_id: {_neq: "$userID"}}) {
    id
    is_finished
    is_directory
    title
    description
    created_at
    updated_at
    last_updated_user_id
    is_deleted
    last_updated_user {
      id
      name
      icon_id
    }
  }
}
''';
}

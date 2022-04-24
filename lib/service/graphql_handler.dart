import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/env.dart';

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

  Future<dynamic> query(String query) async {
    final result = await client.value.query<dynamic>(QueryOptions<dynamic>(
      document: gql(query),
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

String fetchUserGoodsItems(String? userId) {
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
      last_updated_user {
        id
        name
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
        goods_item: {
          data: {
            title: "\$title",
            goods_item_id: "0",
            last_updated_user_id: "\$user_id",
            description: "\$description"
          }
        },
        user_goods_item: {data: {user_id: "\$user_id"}}
      }
    ) {
      returning {
        id
        goods_item_id
      }
    }
  }
''';

String updateGoodsItem = '''
mutation UpdateGoodsItem (\$id: uuid!, \$is_finished: Boolean) {
  update_goods_item_by_pk(pk_columns: {id: \$id}, _set: {is_finished: \$is_finished}) {
    updated_at
  }
}
''';

String fetchGoodsItems(String goodsItemID) {
  return '''
subscription fetchGoodsItem {
  goods_item(order_by: {created_at: desc, is_directory: desc, id: desc}, where: {goods_item_id: {_eq: "$goodsItemID"}}) {
    id
    is_finished
    is_directory
    title
    description
    created_at
    updated_at
    last_updated_user {
      id
      name
      icon_id
    }
  }
}
''';
}

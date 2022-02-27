import 'package:flutter/material.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlObject {
  static final _token = GRAPHQL_TOKEN;
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
      inactivityTimeout: Duration(seconds: 30),
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

  Future<QueryResult> query(String query) async {
    final QueryResult result = await client.value.query(QueryOptions(
      document: gql(query),
    ));

    if (result.hasException) {
      // エラー処理
      print(result.exception);
      for (final GraphQLError error in result.exception!.graphqlErrors) {
        print(error.message);
      }
    }

    return result;
  }
}

GraphQlObject graphQlObject = GraphQlObject();

String addNewUser(String name, int icon_id) {
  return ("""
    mutation {
      insert_user(objects: {name: "$name", icon_id: $icon_id}) {
        returning {
          id
          name
          icon_id
        }
      }
    }
  """);
}

String fetchUserGoodsItems(String? user_id) {
  return ("""
    query fetchUserGoodsItems {
      user_goods_item (where: {user_id: {_eq: "$user_id"}}) {
        id
        goods_item {
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
  """);
}

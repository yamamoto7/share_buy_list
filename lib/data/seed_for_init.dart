String seedQueryForInit(String userId) {
  return '''
mutation {
  insert_goods_item(
    objects: {
      user_goods_items: {
        data: {user_id: "$userId"}
      },
      title: "サンプル買い物リスト",
      last_updated_user_id: "$userId",
      is_directory: true,
      description: "初めてのお買い物リスト\\n右上の3点ドットから編集・削除・ユーザー招待ができます",
      goods_items: {
        data: [
          {
            is_directory: true,
            last_updated_user_id: "$userId",
            title: "食料品"
            goods_items: {
              data: [
                {
                  is_directory: true,
                  last_updated_user_id: "$userId",
                  title: "飲み物",
                  goods_items: {
                    data: [
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "コーヒー"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "牛乳"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "水出し烏龍茶パック"
                      }
                    ]
                  }
                },
                {
                  is_directory: true,
                  last_updated_user_id: "$userId",
                  title: "調味料",
                  goods_items: {
                    data: [
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "砂糖"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "油"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "醤油"
                      }
                    ]
                  }
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍖鶏肉",
                  description: "鶏むね 90円/100g 以下"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍖牛肉",
                  description: "ひき肉 130円/100g 以下"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍖豚肉",
                  description: "バラ肉 110円/100g 以下\\n肩ロース120円/100g 以下"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍅トマト"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🧅玉ねぎ"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🥔じゃがいも"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍚米"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "🍟冷凍ポテト"
                }
              ]
            }
          },
          {
            is_directory: true,
            last_updated_user_id: "$userId",
            title: "日用品"
            goods_items: {
              data: [
                {
                  is_directory: true,
                  last_updated_user_id: "$userId",
                  title: "洗面台・お風呂"
                  goods_items: {
                    data: [
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "シャンプー"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "リンス - メンズ"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "リンス - ウィメンズ"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "ハンドソープ"
                      },
                    ]
                  }
                },
                {
                  is_directory: true,
                  last_updated_user_id: "$userId",
                  title: "キッチン"
                  goods_items: {
                    data: [
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "アルミホイル"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "キッチンペーパー"
                      }
                    ]
                  }
                },
                {
                  is_directory: true,
                  last_updated_user_id: "$userId",
                  title: "その他消耗品"
                  goods_items: {
                    data: [
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "ティッシュ"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "トイレットペーパー"
                      },
                      {
                        is_directory: false,
                        last_updated_user_id: "$userId",
                        title: "消臭スプレー"
                      }
                    ]
                  }
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "車用のゴミ箱"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "掃除機"
                }
              ]
            }
          },
          {
            is_directory: true,
            last_updated_user_id: "$userId",
            title: "防災グッズ"
            goods_items: {
              data: [
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "10年水"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "保存食"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "懐中ライト"
                },
                {
                  is_directory: false,
                  last_updated_user_id: "$userId",
                  title: "軍手"
                },
              ]
            }
          },
          {
            title: "下の + ボタンから、アイテムを追加！",
            last_updated_user_id: "$userId",
            is_directory: false,
            description: "ToDoリストとしても使えるよ！",
          },
          {
            title: "アイテムを←にスワイプ",
            last_updated_user_id: "$userId",
            is_directory: false,
            description: "編集・削除が可能です😃",
          },
          {
            title: "アイテムをタップで切り替え！",
            last_updated_user_id: "$userId",
            is_directory: false,
          }
        ]
      }
    }
  ) {
    returning {
      id
    }
  }
}
  ''';
}

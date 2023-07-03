import 'package:amazon_cognito_identity_dart_2/cognito.dart';

const cognitoDomain = 'xxx.auth';
const cognitoRegion = 'ap-northeast-1';
const cognitoUserPoolId = 'ap-northeast-1_xxxxxxxxx';

// アプリクライアントID
// ex.) 'xxxxxxxxxxxxxxxxxxxxxxxxxx'
const cognitoClientId = 'xxxxxxxxxxxxxxxxxxxxxxxxxx';

// コールバックURL
// "://"が含まれないことに注意
const callbackScheme = 'myapp';

// 今回はAUthorization Codeでのレスポンスが欲しいので'code'を指定
// ほかにも'token'なども指定可能
const cognitoOAuthResponseType = 'code';

// ユーザープールで設定したScopeのうちここで使いたいScopeをスペースで区切って入力
const cognitoScope = 'openid email';

// Create Cognito User Pool
// 上で設定したプールIDとアプリクライアントIDをつかって, CognitoUserPoolクラスのオブジェクトを作成.
// これ以降, このオブジェクトを使いまくります
final cognitoUserPool = CognitoUserPool(cognitoUserPoolId, cognitoClientId);

// Cognito ID Pool
// IDプールのID
// ex.) 'us-east-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
const cognitoIdentityPoolId =
    'ap-northeast-1:xxxxxxxx-ed33-457c-8686-67db360107b6';

// Lambda / API Gateway
// ex.) 'https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com'
const apiEndpoint = 'https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com';
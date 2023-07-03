import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:share_buy_list/amplifyconfiguration.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  Future<bool> signup(String email, String password, String key) async {
    // Registration
    try {
      final cognitoUserPoolData = await cognitoUserPool.signUp(email, password);
      await cognitoUserPoolData.user.confirmRegistration(key);
      return true;
    } on CognitoClientException catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // print(
    // 'https://share-buy-list-ychof-com.auth.ap-northeast-1.amazoncognito.com/login?identity_provider=Google&response_type=code&client_id=$cognitoClientId&scope=openid%20email&redirect_uri=shareBuyListYchof://');
    // Google: https://share-buy-list-ychof-com.auth.ap-northeast-1.amazoncognito.com/oauth2/authorize?identity_provider=Google&response_type=token&client_id=2cdrj1gh6cs8c5bctvupseefdg&scope=openid%20email&redirect_uri=shareBuyListYchof://

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SignInButton(
              Buttons.Google,
              text: 'Sign up with Google',
              onPressed: () async {
                final url = Uri.https(
                  '$cognitoDomain.$cognitoRegion.amazoncognito.com',
                  'oauth2/authorize',
                  <String, String>{
                    'identity_provider': 'Google',
                    'response_type': 'code',
                    'client_id': cognitoClientId,
                    'scope': 'openid email',
                    'redirect_uri': 'shareBuyListYchof://'
                  },
                );
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
            ),
            SignInButton(
              Buttons.FacebookNew,
              text: 'Sign up with Facebook',
              onPressed: () async {
                final url = Uri.https('google.com', '/');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
            ),
            SignInButton(
              Buttons.Twitter,
              text: 'Sign up with Twitter',
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Apple,
              text: 'Sign up with Apple',
              onPressed: () {},
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
    );
  }
}

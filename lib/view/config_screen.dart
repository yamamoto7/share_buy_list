import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_buy_list/view/webview_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          CupertinoNavigationBar(middle: Text(L10n.of(context)!.setting)),
      child: SafeArea(
        bottom: false,
        child: SettingsList(
          applicationType: ApplicationType.cupertino,
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: Text(L10n.of(context)!.settingAccount),
              tiles: [
                SettingsTile.navigation(
                  onPressed: (_) {},
                  title: Text(L10n.of(context)!.settingUserName),
                  value: Text('hogehgoe'),
                ),
              ],
            ),
            SettingsSection(
              title: Text('UI setting'),
              tiles: [
                SettingsTile.navigation(
                    onPressed: (_) {},
                    title: Text(L10n.of(context)!.settingLanguage),
                    value: Text(Config.getLanguageLabel())),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      Config.setDarkMode(value);
                    });
                  },
                  initialValue: Config.darkmode,
                  title: Text(L10n.of(context)!.settingDarkMode),
                ),
              ],
            ),
            SettingsSection(
              title: Text('Information'),
              tiles: [
                SettingsTile.navigation(
                  title: Text(L10n.of(context)!.settingContact),
                  onPressed: (_) {
                    WidgetsBinding.instance
                        ?.addPostFrameCallback((_) => Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const WebViewScreen(
                                        title: '問い合わせ',
                                        url:
                                            'https://docs.google.com/forms/d/e/1FAIpQLScIq5olkqW5iIw1PdxWeNKoIx9YBvcsu6YaOOwclsPywcfEbg/viewform?usp=fb_send_twt'),
                              ),
                            ));
                  },
                ),
                SettingsTile.navigation(
                  title: Text(L10n.of(context)!.settingAbout),
                  description: Text(L10n.of(context)!.settingAboutDescription),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

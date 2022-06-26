import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_buy_list/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool darkTheme = true;

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
                  value: Text(Config.getLanguageLabel()),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      darkTheme = value;
                    });
                  },
                  initialValue: darkTheme,
                  title: Text(L10n.of(context)!.settingDarkMode),
                ),
              ],
            ),
            SettingsSection(
              title: Text('Information'),
              tiles: [
                SettingsTile.navigation(
                  title: Text(L10n.of(context)!.settingContact),
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

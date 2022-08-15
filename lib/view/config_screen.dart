import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_buy_list/config/config.dart';
import 'package:share_buy_list/view/webview_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen(
      {Key? key, required this.setThememode, required this.setLanguage})
      : super(key: key);
  final Function setThememode;
  final Function setLanguage;
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    _selectedLanguageCode = Config.currentLanguageItem.code;
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
                  value: const Text('hogehgoe'),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('UI setting'),
              tiles: [
                SettingsTile.navigation(
                    onPressed: (_) {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Color(0xffffffff),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xff999999),
                                      width: 0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                      child: Text(L10n.of(context)!.cancel),
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        widget.setLanguage(
                                            context,
                                            Config
                                                .languageItems[
                                                    _selectedLanguageCode]!
                                                .locale);
                                        Config.setLanguage(
                                            _selectedLanguageCode);
                                        Navigator.pop(context);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                      child: Text(L10n.of(context)!.confirm),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 320,
                                color: const Color(0xfff7f7f7),
                                child: CupertinoPicker(
                                  magnification: 1.22,
                                  squeeze: 1.2,
                                  useMagnifier: true,
                                  itemExtent: 32,
                                  // This is called when selected item is changed.
                                  scrollController: FixedExtentScrollController(
                                      initialItem: Config
                                          .languageItems[_selectedLanguageCode]!
                                          .getIndex()),
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedLanguageCode =
                                          Config.languageKeys[selectedItem]!;
                                    });
                                  },
                                  children: List<Widget>.generate(
                                      Config.languageKeys.length, (int index) {
                                    return Center(
                                      child: Text(
                                        Config.languageItems[
                                                Config.languageKeys[index]]!
                                            .getLabel(),
                                      ),
                                    );
                                  }),
                                  /* the rest of the picker */
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    title: Text(L10n.of(context)!.settingLanguage),
                    value: Text(Config.getLanguageLabel())),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      Config.setDarkMode(value);
                      widget.setThememode(context, Config.themeMode, '');
                    });
                  },
                  initialValue: Config.darkmode,
                  title: Text(L10n.of(context)!.settingDarkMode),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Information'),
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
                  description: Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

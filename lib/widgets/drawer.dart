// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/friend_request.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/home.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/scenes/main/settings.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/sub/login.dart';

Widget getAccountList() {
  AccountConfig? login;
  return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
    return SingleChildScrollView(
      child: Column(children: [
        for (AccountConfig account in appConfig.accountList)
          ListTile(
            title: Text(
              account.displayName ?? AppLocalizations.of(context)!.unknown,
            ),
            trailing: login == account
                ? const Padding(
                    padding: EdgeInsets.only(right: 2, top: 2),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                  )
                : null,
            onTap: () async {
              login = account;
              bool logged = await appConfig.login(context, account);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => logged ? const VRChatMobileHome() : const VRChatMobileLogin(),
                ),
                (_) => false,
              );
            },
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const VRChatMobileSettingsOtherAccount(),
            ),
            (_) => false,
          ),
        )
      ]),
    );
  });
}

Drawer drawer() {
  return Drawer(
    child: SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileHome(),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.home),
                      title: Text(AppLocalizations.of(context)!.home),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileFriends(offline: false),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.wb_sunny),
                      title: Text(AppLocalizations.of(context)!.onlineFriends),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileFriends(offline: true),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.bedtime),
                      title: Text(AppLocalizations.of(context)!.offlineFriends),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatSearch(),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.search),
                      title: Text(AppLocalizations.of(context)!.search),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileFriendRequest(),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.notifications),
                      title: Text(AppLocalizations.of(context)!.friendRequest),
                    ),
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileWorldsFavorite(),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.favorite),
                      title: Text(AppLocalizations.of(context)!.favoriteWorlds),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.close),
                    ),
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).size.height > 500)
              Column(children: [
                const Divider(),
                ListTile(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VRChatMobileSettings(),
                    ),
                    (_) => false,
                  ),
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.setting),
                ),
                ListTile(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    builder: (_) => getAccountList(),
                  ),
                  leading: const Icon(Icons.account_circle),
                  title: Text(AppLocalizations.of(context)!.accountSwitch),
                ),
              ]),
            if (MediaQuery.of(context).size.height <= 500)
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSettings(),
                      ),
                      (_) => false,
                    ),
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      builder: (_) => getAccountList(),
                    ),
                    icon: const Icon(Icons.account_circle),
                  ),
                ],
              )
          ],
        ),
      ),
    ),
  );
}

Drawer simpleDrawer() {
  return Drawer(
    child: SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                ListTile(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VRChatMobileHome(),
                    ),
                    (_) => false,
                  ),
                  leading: const Icon(Icons.home),
                  title: Text(AppLocalizations.of(context)!.home),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.close),
                )
              ]),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSettings(),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.setting),
                  ),
                  ListTile(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      builder: (_) => getAccountList(),
                    ),
                    leading: const Icon(Icons.account_circle),
                    title: Text(AppLocalizations.of(context)!.accountSwitch),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

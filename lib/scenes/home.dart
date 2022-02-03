import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  _LoginHomeState() {
    getLoginSession("LoginSession").then((cookie) {
      if (cookie == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const VRChatMobileLogin(),
            ),
            (_) => false);
      } else {
        VRChatAPI(cookie: cookie).user().then((response) {
          setState(() {
            column = profile(response);
          });
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      drawer: drawr(context),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: SingleChildScrollView(child: column))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;

  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  int offset = 0;

  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  Users dataColumn = Users();
  _FriendsPageState() {
    moreOver();
  }
  moreOver() {
    getLoginSession("LoginSession").then((response) {
      VRChatAPI(cookie: response).friends(offline: widget.offline, offset: offset).then((response) {
        offset += 50;
        setState(() {
          column = Column(
            children: dataColumn.adds(response),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dataColumn.context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('フレンド'),
      ),
      drawer: drawr(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(children: [
                column,
                if (dataColumn.children.length == offset)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        ElevatedButton(
                          child: const Text('続きを読み込む'),
                          onPressed: () => moreOver(),
                        ),
                      ],
                    ),
                  )
              ])))),
    );
  }
}

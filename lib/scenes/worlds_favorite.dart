import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;

  const VRChatMobileWorldsFavorite({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  List<int> offset = [];
  List<Column> childrenList = [];

  Column column = Column(
    children: const <Widget>[
      Text('ロード中です'),
    ],
  );

  _WorldsFavoriteState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).favoriteGroups("world", offset: 0).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        if (response.isEmpty) {
          setState(() => column = Column(
                children: const <Widget>[
                  Text('なし'),
                ],
              ));
        } else {
          final List<Widget> children = [];
          response.forEach((dynamic index, dynamic list) {
            children.add(Column(
              children: <Widget>[
                Text(list["displayName"]),
              ],
            ));
          });
          column = Column(children: children);
        }
        response.forEach((dynamic index, dynamic list) {
          offset.add(0);
          childrenList.add(Column());
          moreOver(list, index);
        });
      });
    });
  }

  moreOver(Map list, int index) {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).favoritesWorlds(list["name"], offset: offset[index]).then((worlds) {
        if (worlds.containsKey("error")) {
          error(context, worlds["error"]["message"]);
          return;
        }

        offset[index] += 50;
        final List<Widget> worldList = [];
        worldList.addAll(childrenList[index].children);
        worlds.forEach((dynamic index, dynamic world) {
          worldList.add(worldSlim(context, world));
        });
        childrenList[index] = Column(children: worldList);
        column = Column(children: column.children);
        setState(() {
          column.children[index] = Column(children: [
            Text(list["displayName"]),
            Column(children: childrenList[index].children),
            if (childrenList[index].children.length == offset[index] && offset[index] > 0)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('続きを読み込む'),
                      onPressed: () => moreOver(list, index),
                    ),
                  ],
                ),
              )
          ]);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('お気に入りのワールド'),
        ),
        drawer: drawr(context),
        body: SafeArea(child: SizedBox(width: MediaQuery.of(context).size.width, child: SingleChildScrollView(child: column))));
  }
}
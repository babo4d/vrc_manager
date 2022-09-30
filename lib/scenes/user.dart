// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;
  final AppConfig appConfig;

  const VRChatMobileUser(this.appConfig, {Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  VRChatUser? user;
  VRChatfriendStatus? status;
  VRChatWorld? world;
  VRChatInstance? instance;

  TextEditingController noteController = TextEditingController();

  @override
  initState() {
    super.initState();
    get();
  }

  Future get() async {
    await getUser().then((value) => setState(() {}));
    await getWorld().then((value) => setState(() {}));
  }

  Future getUser() async {
    user = await vrhatLoginSession.users(widget.userId).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
    if (user == null) return;
    noteController.text = user!.note ?? "";
    status = await vrhatLoginSession.friendStatus(widget.userId).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
  }

  Future getWorld() async {
    if (!["private", "offline", "traveling"].contains(user!.location)) {
      world = await vrhatLoginSession.worlds(user!.location.split(":")[0]).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      instance = await vrhatLoginSession.instances(user!.location).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
    }
  }

  editNote() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editNote),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () => vrhatLoginSession.userNotes(user!.id, user!.note = noteController.text).then((VRChatUserNotes response) {
                      Navigator.pop(context);
                      setState(() => user!.note = user!.note == "" ? null : user!.note);
                    }).catchError((status) {
                      apiError(context, widget.appConfig, status);
                    })),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: <Widget>[
        if (status != null) profileAction(context, widget.appConfig, status!, widget.userId, initState),
        share(context, widget.appConfig, "https://vrchat.com/home/user/${widget.userId}")
      ]),
      drawer: Navigator.of(context).canPop() ? null : drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 30,
                left: 30,
              ),
              child: Column(
                children: <Widget>[
                  if (user == null)
                    const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())
                  else ...[
                    profile(context, widget.appConfig, user!),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => editNote(),
                        child: Text(AppLocalizations.of(context)!.editNote),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => VRChatMobileJsonViewer(widget.appConfig, obj: user!.content),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (user!.location == "private") return privateWorld(context, appConfig);
                        if (user!.location == "traveling") return privateWorld(context, appConfig);
                        if (user!.location == "offline") return null;
                        if (world == null) return const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());
                        return instanceWidget(context, appConfig, world!, instance!);
                      }(),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

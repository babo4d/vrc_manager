import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/scenes/main/main.dart';

class GridConfigNotifier extends ChangeNotifier {
  GridConfigId id;
  SortMode sortMode = SortMode.normal;
  DisplayMode displayMode = DisplayMode.normal;
  bool descending = false;
  bool joinable = false;
  bool worldDetails = false;
  bool removeButton = false;

  GridConfigNotifier({required this.id}) {
    List<Future> futureList = [];
    futureList.add(getStorage("sort", id: id.name).then((String? value) => sortMode = SortMode.normal.get(value)));
    futureList.add(getStorage("display_mode", id: id.name).then((String? value) => displayMode = DisplayMode.normal.get(value)));
    futureList.add(getStorage("descending", id: id.name).then((String? value) => descending = (value == "true")));
    futureList.add(getStorage("joinable", id: id.name).then((String? value) => joinable = (value == "true")));
    futureList.add(getStorage("world_details", id: id.name).then((String? value) => worldDetails = (value == "true")));
    futureList.add(getStorage("remove_button", id: id.name).then((String? value) => removeButton = (value == "true")));
    Future.wait(futureList).then((_) => notifyListeners());
  }

  Future setSort(SortMode value) async {
    sortMode = value;
    notifyListeners();
    return await setStorage("sort", value.name, id: id.name);
  }

  Future setDisplayMode(DisplayMode value) async {
    displayMode = value;
    notifyListeners();
    return await setStorage("display_mode", displayMode.name, id: id.name);
  }

  Future setDescending(bool value) async {
    descending = value;
    notifyListeners();
    return await setStorage("descending", descending ? "true" : "false", id: id.name);
  }

  Future setJoinable(bool value) async {
    joinable = value;
    notifyListeners();
    return await setStorage("joinable", joinable ? "true" : "false", id: id.name);
  }

  Future setWorldDetails(bool value) async {
    worldDetails = value;
    notifyListeners();
    return await setStorage("world_details", worldDetails ? "true" : "false", id: id.name);
  }

  Future setRemoveButton(bool value) async {
    removeButton = value;
    notifyListeners();
    return await setStorage("remove_button", removeButton ? "true" : "false", id: id.name);
  }
}

final gridConfigProvider = ChangeNotifierProvider.family<GridConfigNotifier, GridConfigId>((ref, id) => GridConfigNotifier(id: id));

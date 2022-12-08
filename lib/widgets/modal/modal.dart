// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

RoundedRectangleBorder getGridShape() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  );
}

class GridModal extends ConsumerWidget {
  final GridModalConfig gridModalConfig;
  const GridModal({Key? key, required this.gridModalConfig}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    return config.when(
      loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (config) {
        return Column(
          children: <Widget>[
            if (gridModalConfig.sortMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort),
                subtitle: Text(config.sortMode.toLocalization(context)),
                onTap: () => showModalBottomSheetConsumerWidget(
                  context: context,
                  builder: () => GridSortModal(gridSortMode: gridModalConfig.sortMode),
                ),
              ),
            if (gridModalConfig.displayMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.display),
                subtitle: Text(config.displayMode.toLocalization(context)),
                onTap: () => showModalBottomSheetConsumerWidget(
                  context: context,
                  builder: () => GridDisplayModeModal(gridDisplayMode: gridModalConfig.displayMode),
                ),
              ),
            if (gridModalConfig.joinable)
              SwitchListTile(
                  value: config.joinable, title: Text(AppLocalizations.of(context)!.showOnlyAvailable), onChanged: (bool e) => config.setJoinable(e)),
            if (gridModalConfig.worldDetails)
              SwitchListTile(
                  value: config.worldDetails, title: Text(AppLocalizations.of(context)!.worldDetails), onChanged: (bool e) => config.setWorldDetails(e)),
            if (gridModalConfig.removeButton)
              SwitchListTile(
                  value: config.removeButton,
                  title: Text(AppLocalizations.of(context)!.worldUnfavoriteButton),
                  onChanged: (bool e) => config.setRemoveButton(e)),
            if (gridModalConfig.url != null)
              ListTile(
                title: Text(AppLocalizations.of(context)!.openInBrowser),
                onTap: () {
                  Navigator.pop(context);
                  openInBrowser(context, gridModalConfig.url!);
                },
              ),
          ],
        );
      },
    );
  }
}

class GridSortModal extends ConsumerWidget {
  final List<SortMode> gridSortMode;
  const GridSortModal({Key? key, required this.gridSortMode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    return SingleChildScrollView(
      child: config.when(
        loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
        data: (config) {
          return Column(
            children: <Widget>[
              for (SortMode sort in gridSortMode)
                ListTile(
                    title: Text(sort.toLocalization(context)),
                    trailing: config.sortMode == sort ? const Icon(Icons.check) : null,
                    onTap: () => config.setSort(sort)),
              SwitchListTile(value: config.descending, title: Text(AppLocalizations.of(context)!.descending), onChanged: (bool e) => config.setDescending(e)),
            ],
          );
        },
      ),
    );
  }
}

class GridDisplayModeModal extends ConsumerWidget {
  final List<DisplayMode> gridDisplayMode;
  const GridDisplayModeModal({Key? key, required this.gridDisplayMode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    return SingleChildScrollView(
      child: config.when(
        loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
        data: (config) {
          return Column(
            children: <Widget>[
              for (DisplayMode display in gridDisplayMode)
                ListTile(
                  title: Text(display.toLocalization(context)),
                  trailing: config.displayMode == display ? const Icon(Icons.check) : null,
                  onTap: () => config.setDisplayMode(display),
                ),
              SwitchListTile(
                value: config.descending,
                title: Text(AppLocalizations.of(context)!.descending),
                onChanged: (bool e) => config.setDescending(e),
              ),
            ],
          );
        },
      ),
    );
  }
}

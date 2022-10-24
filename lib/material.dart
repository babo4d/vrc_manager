// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/main.dart';

MaterialApp getMaterialApp(Widget home, WidgetRef ref) {
  return MaterialApp(
    title: 'VRChat Mobile Client',
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''),
      Locale('ja', ''),
      Locale('es', ''),
      Locale('pt', ''),
      Locale('ru', ''),
      Locale('th', ''),
      Locale('zh', ''),
    ],
    locale: Locale(appConfig.languageCode.name, ''),
    theme: ref.read(appConfig.themeBrightness).value.toTheme(),
    darkTheme: ref.read(appConfig.themeBrightness).value.toTheme(dark: true),
    home: home,
  );
}

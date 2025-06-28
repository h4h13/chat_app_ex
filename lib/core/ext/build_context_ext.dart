import 'package:chat_app_ex/localization/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
}

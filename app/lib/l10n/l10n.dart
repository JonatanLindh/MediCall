import 'package:flutter/widgets.dart';
import 'package:medicall/l10n/generated/app_localizations.g.dart';

export 'package:medicall/l10n/generated/app_localizations.g.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

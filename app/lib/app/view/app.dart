import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/l10n/l10n.dart';
import 'package:medicall/repositories/geo/geo.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => GeoRepository(),
      child: BlocProvider(
        create: (context) =>
            GeoBloc(geoRepository: context.read<GeoRepository>())
              ..add(GeoSubscriptionRequested()),
        child: BlocListener<GeoBloc, GeoState>(
          listener: (context, state) {
            log(state.toString());
          },
          child: MaterialApp.router(
            routerConfig: router,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}

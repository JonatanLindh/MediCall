import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/contants/colorscheme.dart';
import 'package:medicall/l10n/l10n.dart';
import 'package:medicall/repositories/geo/geo.dart';
import 'package:medicall/screens/patient/login/bloc/login_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => GeoRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GeoBloc(geoRepository: context.read<GeoRepository>())
                  ..add(GeoSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
        ],
        child: BlocListener<GeoBloc, GeoState>(
          listener: (context, state) {
            print(state);
            log(state.toString());
          },
          child: MaterialApp.router(
            routerConfig: router,
            theme: ThemeData(
              colorScheme: colorScheme,
              textTheme: GoogleFonts.lexendTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
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

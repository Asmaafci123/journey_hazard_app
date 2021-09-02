import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'core/services/navigation_service/navigation_service.dart';
import 'core/sqllite/sqlite_api.dart';
import 'features/mobile/presentation/pages/send-mobile-page.dart';
import 'features/home.dart';
import 'features/login/presentation/pages/login-page.dart';
import 'features/profile/presentation/pages/profile.dart';
import 'features/splsh/presentation/pages/splash-page.dart';
import 'features/trips/presentation/bloc/risk_bloc.dart';
import 'features/trips/presentation/bloc/trip-bloc.dart';
import 'features/trips/presentation/bloc/trip-state.dart';
import 'features/trips/presentation/pages/trips.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:wakelock/wakelock.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en', 'fil'],
    assetsDirectory: 'assets/langs/',
    apiKeyGoogle: '<Key>', // NOT YET TESTED
  ); // intialize

  runApp(LocalizedApp(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();

  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TripBloc>(
          create: (BuildContext context) => TripBloc(),
        ),
        BlocProvider<RiskBloc>(
          create: (BuildContext context) => RiskBloc(),
        ),

      ],
      child: MaterialApp(
          localizationsDelegates: translator.delegates,
          locale: translator.locale,
          supportedLocales: translator.locals(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: SplashWidget.routeName,
          // onGenerateRoute: gNavigationService.onGenerateRoute,
          // navigatorKey: gNavigationService.navigationKey,
//        onGenerateRoute: gNavigationService.onGenerateRoute,
//        navigatorKey: gNavigationService.navigationKey,
          routes: {
            SplashWidget.routeName: (context) => SplashWidget(),
            LoginWidget.routeName: (context) => LoginWidget(),
            SendMobileWidget.routeName: (context) => SendMobileWidget(),
            HomeWidget.routeName: (context) => HomeWidget(),
            TripsWidget.routeName: (context) => TripsWidget(), //map
//            ProfileWidget.routeName: (context) => ProfileWidget(),
          }
      ),
    );
  }
}





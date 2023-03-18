import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/core/bloc_observer.dart';
import 'package:journeyhazard/features/mobile/presentation/pages/safety_distnarions_page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'core/constants.dart';
import 'core/services/local_storage/local_storage_service.dart';
import 'core/services/navigation_service/navigation_service.dart';
import 'core/sqllite/sqlite_api.dart';
import 'features/login/data/models/user.dart';
import 'features/mobile/presentation/pages/send-mobile-page.dart';

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
  Bloc.observer = MyBlocObserver();

  await translator.init(
   localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en', 'fil', 'hi', 'ur', 'es'],
    assetsDirectory: 'assets/langs/',
   // apiKeyGoogle: '<Key>', // NOT YET TESTED
  ); // intialize
  await CacheHelper.init();
  shipmentId = CacheHelper.getData(key: 'shipmentId');

  final driverDataDB = await DBHelper.getData('driver_data');
  if (driverDataDB.isNotEmpty) {
    userDataRef = UserModel.fromJson(driverDataDB.first);
    if (userDataRef.shipmentId != null)
      CacheHelper.saveData(key: 'shipmentId', value: userDataRef.shipmentId);
    shipmentId = userDataRef.shipmentId;
  }
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
            highlightColor: Colors.white.withOpacity(0.25),
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              splashColor: Colors.white.withOpacity(0.25),
            ),
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
            SafetyDestinationsPage.routeName:(context)=>SafetyDestinationsPage(),
            TripsWidget.routeName: (context) => TripsWidget(), //map
//            ProfileWidget.routeName: (context) => ProfileWidget(),
          }),
    );
  }
}

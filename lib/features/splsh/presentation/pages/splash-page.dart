import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
import 'package:journeyhazard/features/login/presentation/pages/login-page.dart';
import 'package:flutter/material.dart';
import 'package:journeyhazard/features/mobile/presentation/pages/safety_distnarions_page.dart';
import 'package:journeyhazard/features/mobile/presentation/pages/send-mobile-page.dart';
import 'package:journeyhazard/features/splsh/presentation/bloc/splash-bloc.dart';
import 'package:journeyhazard/features/splsh/presentation/bloc/splash-event.dart';
import 'package:journeyhazard/features/splsh/presentation/bloc/splash-state.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:native_updater/native_updater.dart';
import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';
import 'logo_widget.dart';
import 'package:new_version/new_version.dart';

class SplashWidget extends StatefulWidget {
  /// splash screen (1)
  static const routeName = 'SplashWidget';

  SplashWidgetState createState() => SplashWidgetState();
}

//new
class SplashWidgetState extends State<SplashWidget> {
  double _logoWidth = 90.0;
  SplashBloc _splashBloc = SplashBloc(BaseSplashState());
  final newVersion = NewVersion(
    androidId: 'com.cemex.journeyhazard',
  );

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    Future.delayed(Duration(milliseconds: 50), () {
      _logoWidth = 40.0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  Future<void> checkForUpdate() async {
    final status = await newVersion.getVersionStatus().then((value) {
      if (value != null && value?.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          dialogTitle: "Update",
          versionStatus: value,
          dialogText:
              "Hazar recommends that you update to the latest version. You can keep using this app while downloading the update.",
          dismissAction: () => _splashBloc.add(GetSplashEvent()),
        );
      }
    }, onError: (err) {
      print(err);
    });
    _splashBloc.add(GetSplashEvent());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    ScreensHelper(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(SHHNATY_BACK_GROUND), fit: BoxFit.cover),
            ),
            child: Container(
              child: Center(
                  child: AnimatedContainer(
                width: ScreensHelper.fromWidth(_logoWidth),
                height: ScreensHelper.fromHeight(60),
                curve: Curves.bounceOut,
                duration: Duration(milliseconds: 1000),
                child: LogoWidget(),
              )
                  //  child: LogoWidget(width: 90.00,),
                  ),
            ),
          ),
          Positioned(
            width: ScreensHelper.width,
            height: ScreensHelper.fromHeight(0.5),
            bottom: ScreensHelper.fromHeight(4),
            child: BlocConsumer<SplashBloc, BaseSplashState>(
              bloc: _splashBloc,
              listener: (context, state) {
                if (state is SplashSuccessState) {
                  print(state.goToSafetDestinationsPage);
                  print(state.goToHomePage);
                  // print('${state.goToLoginPage}, ${state.goToHomePage}');
                  if (state.goToSafetDestinationsPage) {
                    Navigator.pushReplacementNamed(
                        context, SafetyDestinationsPage.routeName,
                        arguments: state.userData);
                  }
                  if (state.goToLoginPage) {
                    Navigator.pushReplacementNamed(
                        context, LoginWidget.routeName);
                  }
                  if (state.goToMobilePage) {
                    Navigator.pushReplacementNamed(
                        context, SendMobileWidget.routeName);
                  }
                  if (state.goToHomePage) {
                    Navigator.pushReplacementNamed(
                        context, TripsWidget.routeName,
                        arguments: state.userData);
                  }
                }
              },
              builder: (context, state) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreensHelper.fromWidth(33)),
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ScreensHelper.fromWidth(10)),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              GlobalColors.darkGreen),
                        )),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// end new

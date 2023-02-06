import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journeyhazard/core/constants.dart';
import 'package:journeyhazard/features/login/data/models/user.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-bloc.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-events.dart';
import 'package:journeyhazard/features/mobile/presentation/bloc/mobile-state.dart';
import 'package:journeyhazard/features/share/loading-dialog.dart';
import 'package:journeyhazard/features/trips/presentation/pages/trips.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';

class SafetyDestinationsPage extends StatefulWidget {
  const SafetyDestinationsPage({Key key}) : super(key: key);
  static const routeName = 'SafetyDestinationPage';

  @override
  State<SafetyDestinationsPage> createState() => _SafetyDestinationsPageState();
}

class _SafetyDestinationsPageState extends State<SafetyDestinationsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SendMobileBloc _bloc = SendMobileBloc(BaseSendMobileState());
  UserModel userData;
  List<String> destinationsList = [];
  @override
  void initState() {
//    print(translator.currentLanguage);
    super.initState();
    _bloc.add(GetAllDestinations());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as UserModel;
    if (arg != null) userData = arg;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
            child: BlocConsumer(
                bloc: _bloc,
                builder: (context, state) {
                  return Center(
                    child:  Container(
                        height: MediaQuery.of(context).size.height*0.6,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(translator.translate("destination"),
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontFamily: FONT_FAMILY,
                                      fontSize: MediaQuery.of(context).size.width*0.07,
                                      fontWeight: FontWeight.w600)),
                              Container(
                                width: MediaQuery.of(context).size.width*0.5,
                                child: Lottie.asset('assets/lottiefiles/truck.json',
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.05,
                              ),
                              Padding(
                                padding:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.02,0,MediaQuery.of(context).size.width*0.02,0),
                                child: Column(
                                  children: [
                                    DropdownSearch<String>(
                                      items: destinationsList,
                                      validator: (value) => value == null
                                          ? translator.translate("required")
                                          : null,
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      onChanged: (value) {
                                        userData.destination = value;
                                      },
                                      dropdownBuilder: (context, destination) {
                                        return destination != null
                                            ? Text(destination ?? '')
                                            : Padding(
                                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.03, 0, MediaQuery.of(context).size.width*0.03,0),
                                          child: Text(
                                            translator
                                                .translate("destination"),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor,
                                                fontSize: MediaQuery.of(context).size.width*0.04),
                                          ),
                                        );
                                      },
                                      emptyBuilder: (_, __) => Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                translator.translate("no data found"),
                                              )
                                            ],
                                          )),
                                      searchFieldProps: TextFieldProps(
                                          style: TextStyle(
                                              color: const Color(0xff767676),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              size: 30,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width -
                                          40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          if (!_formKey.currentState.validate()) {
                                            return;
                                          }
                                          if (_formKey.currentState.validate()) {
                                            print(userData.toJson());
                                            _bloc.add(SendMobileEvent(
                                                userModel: this.userData));
                                          }
                                        },
                                        child: Text(
                                          translator.translate('next'),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width*0.04,
                                              color: Colors.white,
                                              fontFamily: FONT_FAMILY,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  );
                },
                listener: (context, state) {
                  if (state is SendMobileSuccessState) {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacementNamed(
                        TripsWidget.routeName,
                        arguments: state.userData);
                  }
                  if (state is SendMobileFailedState) Navigator.pop(context);
                  if (state is SendMobileLoadingState) {
                    loadingAlertDialog(context);
                  }
                  if (state is GetDestinationsSuccessState) {
                    Navigator.pop(context);
                    destinationsList = state.destinations.toList();
                  }
                })),
      ),
    );
  }
}

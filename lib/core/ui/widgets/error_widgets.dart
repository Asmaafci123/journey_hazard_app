//import 'package:flutter/material.dart';
//
//import '../../localization/translations.dart';
//import '../resources.dart';
//
//class DefaultConnectionErrorWidget extends StatelessWidget {
//  final VoidCallback callback;
//
//  const DefaultConnectionErrorWidget({
//    Key key,
//    @required this.callback,
//  }) : super(key: key);
//
//  @override
//  Widget  build(BuildContext context) {
//    return Center(
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            Translations.of(context).text('err_connection'),
//            style: GlobalStyles.k16RegularTextStyle,
//          ),
//          RaisedButton(
//            onPressed: callback,
//            child: Text(
//              Translations.of(context).text('retry'),
//              style: GlobalStyles.k16RegularTextStyle.copyWith(
//                color: Colors.white,
//              ),
//            ),
//            color: Theme.of(context).accentColor,
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class DefaultUnexpectedErrorWidget extends StatelessWidget {
//  final VoidCallback callback;
//
//  const DefaultUnexpectedErrorWidget({
//    Key key,
//    @required this.callback,
//  }) : super(key: key);
//
//  @override
//  Widget  build(BuildContext context) {
//    return Center(
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            Translations.of(context).text('err_unexpected'),
//            style: GlobalStyles.k16RegularTextStyle,
//          ),
//          RaisedButton(
//            onPressed: callback,
//            child: Text(
//              Translations.of(context).text('retry'),
//              style: GlobalStyles.k16RegularTextStyle.copyWith(
//                color: Colors.white,
//              ),
//            ),
//            color: Theme.of(context).accentColor,
//          ),
//        ],
//      ),
//    );
//  }
//}
import 'package:flutter/material.dart';

class PickImageBottomSheet extends StatelessWidget {
  @override
  Widget  build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
    );
  }
}

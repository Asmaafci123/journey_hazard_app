import 'package:flutter/material.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';

class PersonPlaceholderWidget extends StatelessWidget {
  @override
  Widget  build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/person_placeholder.png',
          fit: BoxFit.cover,
          color: GlobalColors.darkGrey,
        ),
      ),
    );
  }
}

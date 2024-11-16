import 'package:flutter/material.dart';

import '../../../../../utils/constants/text_strings.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MAppTexts.signupTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          MAppTexts.signupSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

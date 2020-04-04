import 'package:flutter/material.dart';

class BottomSheetText extends StatelessWidget {
  const BottomSheetText({
    this.question,
    this.result,
  });

  final String question;
  final String result;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: '$question: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              )),
          TextSpan(
            text: '$result',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}

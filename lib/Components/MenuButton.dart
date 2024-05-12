import 'package:flutter/material.dart';

import 'Components.dart';

class MenuButton extends StatelessWidget {
  final double len, textSize;
  final String assetPath, text;

  MenuButton(this.len, this.assetPath, this.text, this.textSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyAssetImageView(assetPath),
              )),
          const SizedBox(
            height: 4,
          ),
          MyTextView(
              text, textSize, FontWeight.w500, Colors.white, TextAlign.center)
        ],
      ),
    );
  }
}
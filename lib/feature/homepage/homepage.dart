import 'package:flutter/material.dart';
import 'package:sikors/core/assets/asset.dart';
import 'package:sikors/core/design/color.dart';
import 'package:sikors/core/design/typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DefColor.colorRed200,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: DefColor.colorNeutral50,
              borderRadius: BorderRadius.all(Radius.circular(1000))),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            DefAsset.icSikors,
            width: 24,
            height: 24,
          ),
        ),
        title: Text(
          'Sikors',
          style:
              DefTypography.headlineSmall.copyWith(color: DefColor.colorRed900),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Home Page',
            style: DefTypography.titleLarge.copyWith(
              color: DefColor.colorRed900,
            ),
          ),
        ),
      ),
    );
  }
}

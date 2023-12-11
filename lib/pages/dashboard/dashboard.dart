
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../extensions/widget_extension.dart';
import '../../themes/app_fonts.dart';
import '../../widgets/scan_nfc_button/scan_nfc_button.dart';

@RoutePage()
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Scan NFC Tag',
          style: TextStyle(color: Colors.black, fontFamily: FontFamily.RedHatMedium),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 70,
              child: Image.asset('assets/images/coinpluslogo.png'),
            ),
            const ScanNfcButton(
              isInInfoPage: false,
            ).paddingHorizontal(60),
          ],
        ),
      ),
    );
  }
}

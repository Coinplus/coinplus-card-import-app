import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:nxp_originality_verifier/nxp_originality_verifier.dart';

import '../../extensions/elevated_button_extensions.dart';
import '../../extensions/extensions.dart';
import '../../router.dart';
import '../../services/firestore_service/firestore_service.dart';
import '../../services/screen_services.dart';
import '../../themes/app_fonts.dart';
import '../loading_button.dart';

class ScanNfcButton extends StatelessWidget {
  const ScanNfcButton({super.key, required this.isInInfoPage});

  final bool isInInfoPage;

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      onPressed: Platform.isIOS
          ? () async {
              await NfcManager.instance.startSession(
                alertMessage: 'Hold your phone near the Coinplus Card.',
                onDiscovered: (tag) async {
                  final ndef = Ndef.from(tag);
                  final records = ndef!.cachedMessage!.records;
                  dynamic walletAddress;
                  dynamic cardColor;
                  dynamic formFactor;
                  dynamic isOriginalTag = false;
                  dynamic serialNumber;
                  final recordsLength = records.length;
                  if (recordsLength >= 2) {
                    final hasJson = records[1].payload;
                    final payloadString = String.fromCharCodes(hasJson);
                    final Map payloadData = await json.decode(payloadString);
                    walletAddress = payloadData['a'];
                    cardColor = payloadData['c'];
                    formFactor = payloadData['t'];
                    serialNumber = payloadData['s'];
                  } else {
                    final hasUrl = records[0].payload;
                    final payloadString = String.fromCharCodes(hasUrl);
                    final parts = payloadString.split('air.coinplus.com/btc/');
                    walletAddress = parts[1];
                  }
                  final mifare = MiFare.from(tag);
                  final tagId = mifare!.identifier;
                  final formattedTagId = tagId.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
                  final signature = await mifare.sendMiFareCommand(
                    Uint8List.fromList(
                      [0x3C, 0x00],
                    ),
                  );
                  if (signature.length > 2) {
                    isOriginalTag = OriginalityVerifier().verify(
                      tagId,
                      signature,
                    );
                  }
                  final firestore = FirebaseFirestore.instance;
                  final DocumentReference documentReference = firestore.collection('cards').doc(walletAddress);
                  await NfcManager.instance.stopSession(alertMessage: 'Completed');
                  final documentSnapshot = await documentReference.get();
                  final card = await getCardData(walletAddress);
                  await router.pop();
                  await router.pushAndPopAll(
                    CardInfoRoute(
                      cardColor: cardColor,
                      formFactor: formFactor,
                      walletAddress: walletAddress,
                      isOriginalTag: isOriginalTag,
                      tagId: formattedTagId,
                      recordsLength: recordsLength,
                      isExistsInDb: documentSnapshot.exists,
                      barcodeIdFromDb: card?.barcodeId,
                      serialNumber: serialNumber,
                    ),
                  );
                },
                onError: (_) => Future(() => null),
              );
            }
          : () async {
              await NfcManager.instance.startSession(
                onDiscovered: (tag) async {
                  final ndef = Ndef.from(tag);
                  final records = ndef!.cachedMessage!.records;
                  dynamic walletAddress;
                  dynamic cardColor;
                  dynamic formFactor;
                  dynamic isOriginalTag = false;
                  dynamic serialNumber;

                  final recordsLength = records.length;
                  if (recordsLength >= 2) {
                    final hasJson = records[1].payload;
                    final payloadString = String.fromCharCodes(hasJson);
                    final Map payloadData = await json.decode(payloadString);
                    walletAddress = payloadData['a'];
                    cardColor = payloadData['c'];
                    formFactor = payloadData['t'];
                    serialNumber = payloadData['s'];

                  } else {
                    final hasUrl = records[0].payload;
                    final payloadString = String.fromCharCodes(hasUrl);
                    final parts = payloadString.split('air.coinplus.com/btc/');
                    walletAddress = parts[1];
                  }

                  final nfcA = NfcA.from(tag);
                  final uid = nfcA!.identifier;
                  final formattedTagId = uid.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
                  Uint8List? signature;

                  try {
                    final response = await nfcA.transceive(
                      data: Uint8List.fromList([0x3C, 0x00]),
                    );
                    signature = Uint8List.fromList(response);
                    if (signature.length > 2) {
                      isOriginalTag = OriginalityVerifier().verify(
                        uid,
                        signature,
                      );
                    }
                  } catch (e) {
                    signature = null;
                  }
                  final card = await getCardData(walletAddress);
                  final firestore = FirebaseFirestore.instance;
                  final DocumentReference documentReference = firestore.collection('cards').doc(walletAddress);
                  final documentSnapshot = await documentReference.get();
                  await router.pop();
                  await router.pushAndPopAll(
                    CardInfoRoute(
                      cardColor: cardColor,
                      formFactor: formFactor,
                      walletAddress: walletAddress,
                      isOriginalTag: isOriginalTag,
                      tagId: formattedTagId,
                      recordsLength: recordsLength,
                      isExistsInDb: documentSnapshot.exists,
                      barcodeIdFromDb: card?.barcodeId,
                      serialNumber: serialNumber,
                    ),
                  );
                },
                onError: (_) => Future(() => null),
              );
              await showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    opacity: 1,
                    child: Container(
                      height: 400,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            40,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Gap(15),
                          const Text(
                            'Ready to Scan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          const Gap(40),
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Lottie.asset(
                              'assets/animated_logo/nfcanimation.json',
                            ).expandedHorizontally(),
                          ),
                          const Gap(25),
                          const Text(
                            'It’s easy! Hold your phone near the Coinplus Card \nor on top of your Coinplus Bar’s box',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ).paddingHorizontal(50),
                          const Gap(20),
                          LoadingButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            style: context.theme
                                .buttonStyle(
                                  textStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                )
                                .copyWith(
                                  backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.3)),
                                ),
                            child: const Text('Cancel'),
                          ).paddingHorizontal(60),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
      child: const Text(
        'Scan Coinplus Card',
        style: TextStyle(fontWeight: FontWeight.normal, fontFamily: FontFamily.RedHatMedium, fontSize: 16),
      ),
    );
  }
}

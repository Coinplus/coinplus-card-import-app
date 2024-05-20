import 'dart:convert';
import 'dart:developer';
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
import '../../models/nfc_tag_model/nfc_tag_model.dart';
import '../../router.gr.dart';
import '../../themes/app_fonts.dart';
import '../../widgets/custom_snack_bar/snack_bar.dart';
import '../../widgets/custom_snack_bar/top_snack.dart';
import '../../widgets/loading_button.dart';
import '../screen_services.dart';

Future<void> setDataWithCustomDocumentId({
  required String? documentID,
  required String? tagId,
  required String? barcodeId,
  required String? cardColor,
  required bool? possibleOldCard,
  required BuildContext context,
  required String type,
}) async {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference collectionReference = firestore.collection('cards');

  final customDocumentId = documentID;

  final card = CardsModel(
    activated: false,
    activationCount: 0,
    activationFailureCount: 0,
    address: documentID,
    approved: true,
    barcodeId: barcodeId,
    color: cardColor,
    connected: 0,
    deleted: 0,
    email: '',
    nfcId: tagId,
    possibleOldCard: possibleOldCard,
    replenished: false,
    replenishmentHistory: [],
    type: type,
    verificationFailureCount: 0,
  );
  final DocumentReference documentReference = firestore.collection('cards').doc(customDocumentId);

  try {
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      showTopSnackBar(
        displayDuration: const Duration(
          milliseconds: 400,
        ),
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: const Color(0xFF4A4A4A).withOpacity(0.9),
          message: 'Data exists',
          textStyle: const TextStyle(
            fontFamily: FontFamily.RedHatMedium,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      );
    } else {
      try {
        final customDocumentRef = collectionReference.doc(customDocumentId);

        final cardMap = card.toJson();

        await customDocumentRef.set(cardMap);
        showTopSnackBar(
          displayDuration: const Duration(
            milliseconds: 400,
          ),
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: const Color(0xFF4A4A4A).withOpacity(0.9),
            message: 'Added successfully',
            textStyle: const TextStyle(
              fontFamily: FontFamily.RedHatMedium,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 1000));
        Platform.isIOS
            ? await NfcManager.instance.startSession(
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
              )
            : androidNfcSession();
      } catch (e) {
        await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Error setting document!'),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: LoadingButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  } catch (e) {
    log('Error checking document existence: $e');
  }
}

Future<CardsModel?> getCardData(String documentId) async {
  final _firestore = FirebaseFirestore.instance;

  final DocumentSnapshot documentSnapshot = await _firestore.collection('cards').doc(documentId).get();

  if (documentSnapshot.exists) {
    final documentData = documentSnapshot.data() as Map<String, dynamic>?;

    if (documentData != null) {
      final card = CardsModel.fromJson(documentData);
      return card;
    }
  } else {}
  return null;
}

Future<void> androidNfcSession() async {
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
    context: router.navigatorKey.currentContext!,
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
}

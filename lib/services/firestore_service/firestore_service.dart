import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/nfc_tag_model/nfc_tag_model.dart';
import '../../widgets/loading_button.dart';

Future<void> setDataWithCustomDocumentId({
  required String? documentID,
  required String? tagId,
  required int? barcodeId,
  required String? cardColor,
  required bool? possibleOldCard,
  required BuildContext context,
  required String type,
}) async {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference collectionReference = firestore.collection('cards');

  final customDocumentId = documentID;

  final card = CardsModel(
    activation: '',
    activationCount: '',
    activationFailureCount: '',
    address: documentID,
    approved: true,
    barcodeId: barcodeId,
    color: cardColor,
    connected: 1,
    email: '',
    nfcId: tagId,
    possibleOldCard: possibleOldCard,
    replenished: [],
    type: type,
    verificationFailureCount: 0,
  );
  final DocumentReference documentReference = firestore.collection('cards').doc(customDocumentId);

  try {
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Data exists!'),
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
    } else {
      try {
        final customDocumentRef = collectionReference.doc(customDocumentId);

        final cardMap = card.toJson();

        await customDocumentRef.set(cardMap);

        await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Data set successfully!'),
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

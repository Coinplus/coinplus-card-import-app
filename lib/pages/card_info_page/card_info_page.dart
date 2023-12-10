import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../services/firestore_service/firestore_service.dart';
import '../../themes/app_fonts.dart';
import '../../widgets/loading_button.dart';

class CardInfoPage extends HookWidget {
  const CardInfoPage({
    super.key,
    required this.cardColor,
    required this.formFactor,
    required this.walletAddress,
    required this.isOriginalTag,
    required this.tagId,
    required this.recordsLength,
    required this.isExistsInDb,
  });

  final String? cardColor;
  final String? formFactor;
  final String? walletAddress;
  final bool? isOriginalTag;
  final String? tagId;
  final int? recordsLength;
  final bool? isExistsInDb;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _nfcStop();
      return null;
    });
    final isOldCard = useState<bool>(recordsLength! < 2 || false);
    final _textFieldController = useTextEditingController();
    late var barcodeId = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'NFC Info',
          style: TextStyle(color: Colors.black, fontFamily: FontFamily.RedHatMedium),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 60,
                  decoration: BoxDecoration(image: getFrontImageForCardColor(cardColor)),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Is exists in DB:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      isExistsInDb.toString(),
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet address:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      walletAddress.toString(),
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tag Serial Number:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      tagId.toString(),
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NXP Original Tag:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      isOriginalTag.toString(),
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card color:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      cardColor == '0'
                          ? 'ORANGE'
                          : cardColor == '1'
                              ? 'WHITE'
                              : cardColor == '2'
                                  ? 'BLACK'
                                  : 'OLD CARD',
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Form factor:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    Text(
                      formFactor == 'c'
                          ? 'CARD'
                          : formFactor == 'b'
                              ? 'BAR'
                              : 'OLD CARD',
                      style: const TextStyle(fontFamily: FontFamily.RedHatMedium),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                const Gap(10),
                const Text(
                  'Possible old card',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                ),
                DropdownButton<bool>(
                  value: isOldCard.value,
                  onChanged: (newValue) {
                    isOldCard.value = newValue!;
                  },
                  items: const <DropdownMenuItem<bool>>[
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text(
                        'True',
                        style: TextStyle(fontFamily: FontFamily.RedHatMedium),
                      ),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text(
                        'False',
                        style: TextStyle(fontFamily: FontFamily.RedHatMedium),
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                const SizedBox(
                  height: 3,
                  width: 350,
                  child: Divider(
                    indent: 1,
                    endIndent: 1,
                    color: Colors.grey,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Barcode ID:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: FontFamily.RedHatMedium),
                    ),
                    const Gap(5),
                    SizedBox(
                      height: 20,
                      width: 120,
                      child: TextField(
                        controller: _textFieldController,
                        onTapOutside: (_) {
                          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                        },
                        onChanged: (value) {
                          barcodeId = value;
                        },
                      ),),
                  ],
                ),
                const Gap(40),
                Row(
                  children: [
                    const Gap(55),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: LoadingButton(
                        onPressed: () async {
                          await setDataWithCustomDocumentId(
                            context: context,
                            documentID: walletAddress,
                            tagId: tagId,
                            type: formFactor == 'c' ? 'CARD' : 'BAR',
                            cardColor: cardColor == '0'
                                ? 'ORANGE'
                                : cardColor == '1'
                                    ? 'WHITE'
                                    : cardColor == '2'
                                        ? 'BLACK'
                                        : 'OLD CARD',
                            possibleOldCard: isOldCard.value,
                            barcodeId: int.tryParse(barcodeId),
                          );
                        },
                        child: const Text(
                          'Add to database',
                          style: TextStyle(fontFamily: FontFamily.RedHatMedium, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Future<void> _nfcStop() async {
  await Future.delayed(const Duration(milliseconds: 3000));
  await NfcManager.instance.stopSession();
}

DecorationImage getFrontImageForCardColor(String? colorNum) {
  switch (colorNum) {
    case '0':
      return DecorationImage(
        image: Image.asset('assets/images/orange_card_front.png').image,
      );
    case '1':
      return DecorationImage(
        image: Image.asset('assets/images/white_card_front.png').image,
      );
    case '2':
      return DecorationImage(
        image: Image.asset('assets/images/brown_card_front.png').image,
      );
    default:
      return DecorationImage(
        image: Image.asset('assets/images/orange_card_front.png').image,
      );
  }

}

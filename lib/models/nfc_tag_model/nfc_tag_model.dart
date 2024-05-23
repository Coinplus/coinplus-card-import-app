import 'package:freezed_annotation/freezed_annotation.dart';




part 'nfc_tag_model.g.dart';


@JsonSerializable()
class ReplenishmentHistory {
  final int amount;
  final String blockchain;
  final String crypto;
  final String currency;
  final DateTime date;
  final int fiatAmount;

  ReplenishmentHistory({
    required this.amount,
    required this.blockchain,
    required this.crypto,
    required this.currency,
    required this.date,
    required this.fiatAmount,
  });

  factory ReplenishmentHistory.fromJson(Map<String, dynamic> json) =>
      _$ReplenishmentHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ReplenishmentHistoryToJson(this);
}

@JsonSerializable()
class CardsModel {
  final bool? activated;
  final int? activationCount;
  final int? activationFailureCount;
  final String? address;
  final bool? approved;
  final String? barcodeId;
  final String? color;
  final int? connected;
  final int? deleted;
  final String? email;
  final String? nfcId;
  final bool? possibleOldCard;
  final bool? replenished;
  final List<Map<String, dynamic>>? replenishmentHistory;
  final String? type;
  final int? verificationFailureCount;
  final String? serialNumber;

  CardsModel({
    this.activated,
    this.activationCount,
    this.activationFailureCount,
    this.address,
    this.approved,
    this.barcodeId,
    this.color,
    this.connected,
    this.deleted,
    this.email,
    this.nfcId,
    this.possibleOldCard,
    this.replenished,
    this.replenishmentHistory,
    this.type,
    this.verificationFailureCount,
    this.serialNumber,
  });

  factory CardsModel.fromJson(Map<String, dynamic> json) =>
      _$CardsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardsModelToJson(this);
}

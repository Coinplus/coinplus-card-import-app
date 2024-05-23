// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplenishmentHistory _$ReplenishmentHistoryFromJson(
        Map<String, dynamic> json) =>
    ReplenishmentHistory(
      amount: json['amount'] as int,
      blockchain: json['blockchain'] as String,
      crypto: json['crypto'] as String,
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      fiatAmount: json['fiatAmount'] as int,
    );

Map<String, dynamic> _$ReplenishmentHistoryToJson(
        ReplenishmentHistory instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'blockchain': instance.blockchain,
      'crypto': instance.crypto,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'fiatAmount': instance.fiatAmount,
    };

CardsModel _$CardsModelFromJson(Map<String, dynamic> json) => CardsModel(
      activated: json['activated'] as bool?,
      activationCount: json['activationCount'] as int?,
      activationFailureCount: json['activationFailureCount'] as int?,
      address: json['address'] as String?,
      approved: json['approved'] as bool?,
      barcodeId: json['barcodeId'] as String?,
      color: json['color'] as String?,
      connected: json['connected'] as int?,
      deleted: json['deleted'] as int?,
      email: json['email'] as String?,
      nfcId: json['nfcId'] as String?,
      possibleOldCard: json['possibleOldCard'] as bool?,
      replenished: json['replenished'] as bool?,
      replenishmentHistory: (json['replenishmentHistory'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      type: json['type'] as String?,
      verificationFailureCount: json['verificationFailureCount'] as int?,
      serialNumber: json['serialNumber'] as String?,
    );

Map<String, dynamic> _$CardsModelToJson(CardsModel instance) =>
    <String, dynamic>{
      'activated': instance.activated,
      'activationCount': instance.activationCount,
      'activationFailureCount': instance.activationFailureCount,
      'address': instance.address,
      'approved': instance.approved,
      'barcodeId': instance.barcodeId,
      'color': instance.color,
      'connected': instance.connected,
      'deleted': instance.deleted,
      'email': instance.email,
      'nfcId': instance.nfcId,
      'possibleOldCard': instance.possibleOldCard,
      'replenished': instance.replenished,
      'replenishmentHistory': instance.replenishmentHistory,
      'type': instance.type,
      'verificationFailureCount': instance.verificationFailureCount,
      'serialNumber': instance.serialNumber,
    };

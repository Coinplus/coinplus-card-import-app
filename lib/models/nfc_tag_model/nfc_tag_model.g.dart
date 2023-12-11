// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardsModel _$CardsModelFromJson(Map<String, dynamic> json) => CardsModel(
      activation: json['activation'] as String?,
      activationCount: json['activationCount'] as String?,
      activationFailureCount: json['activationFailureCount'] as String?,
      address: json['address'] as String?,
      approved: json['approved'] as bool?,
      barcodeId: json['barcodeId'] as int?,
      color: json['color'] as String?,
      connected: json['connected'] as int?,
      email: json['email'] as String?,
      nfcId: json['nfcId'] as String?,
      possibleOldCard: json['possibleOldCard'] as bool?,
      replenished: json['replenished'] as List<dynamic>?,
      type: json['type'] as String?,
      verificationFailureCount: json['verificationFailureCount'] as int?,
    );

Map<String, dynamic> _$CardsModelToJson(CardsModel instance) =>
    <String, dynamic>{
      'activation': instance.activation,
      'activationCount': instance.activationCount,
      'activationFailureCount': instance.activationFailureCount,
      'address': instance.address,
      'approved': instance.approved,
      'barcodeId': instance.barcodeId,
      'color': instance.color,
      'connected': instance.connected,
      'email': instance.email,
      'nfcId': instance.nfcId,
      'possibleOldCard': instance.possibleOldCard,
      'replenished': instance.replenished,
      'type': instance.type,
      'verificationFailureCount': instance.verificationFailureCount,
    };

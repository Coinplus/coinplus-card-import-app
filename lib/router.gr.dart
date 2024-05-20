// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:coinplus_db/pages/card_info_page/card_info_page.dart' as _i1;
import 'package:coinplus_db/pages/dashboard/dashboard.dart' as _i2;
import 'package:flutter/material.dart' as _i4;

abstract class $Router extends _i3.RootStackRouter {
  $Router({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    CardInfoRoute.name: (routeData) {
      final args = routeData.argsAs<CardInfoRouteArgs>();
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CardInfoPage(
          key: args.key,
          cardColor: args.cardColor,
          formFactor: args.formFactor,
          walletAddress: args.walletAddress,
          isOriginalTag: args.isOriginalTag,
          tagId: args.tagId,
          recordsLength: args.recordsLength,
          isExistsInDb: args.isExistsInDb,
          barcodeIdFromDb: args.barcodeIdFromDb,
          serialNumber: args.serialNumber,
        ),
      );
    },
    Dashboard.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Dashboard(),
      );
    },
  };
}

/// generated route for
/// [_i1.CardInfoPage]
class CardInfoRoute extends _i3.PageRouteInfo<CardInfoRouteArgs> {
  CardInfoRoute({
    _i4.Key? key,
    required String? cardColor,
    required String? formFactor,
    required String? walletAddress,
    required bool? isOriginalTag,
    required String? tagId,
    required int? recordsLength,
    required bool? isExistsInDb,
    required String? barcodeIdFromDb,
    required String? serialNumber,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          CardInfoRoute.name,
          args: CardInfoRouteArgs(
            key: key,
            cardColor: cardColor,
            formFactor: formFactor,
            walletAddress: walletAddress,
            isOriginalTag: isOriginalTag,
            tagId: tagId,
            recordsLength: recordsLength,
            isExistsInDb: isExistsInDb,
            barcodeIdFromDb: barcodeIdFromDb,
            serialNumber: serialNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'CardInfoRoute';

  static const _i3.PageInfo<CardInfoRouteArgs> page =
      _i3.PageInfo<CardInfoRouteArgs>(name);
}

class CardInfoRouteArgs {
  const CardInfoRouteArgs({
    this.key,
    required this.cardColor,
    required this.formFactor,
    required this.walletAddress,
    required this.isOriginalTag,
    required this.tagId,
    required this.recordsLength,
    required this.isExistsInDb,
    required this.barcodeIdFromDb,
    required this.serialNumber,
  });

  final _i4.Key? key;

  final String? cardColor;

  final String? formFactor;

  final String? walletAddress;

  final bool? isOriginalTag;

  final String? tagId;

  final int? recordsLength;

  final bool? isExistsInDb;

  final String? barcodeIdFromDb;

  final String? serialNumber;

  @override
  String toString() {
    return 'CardInfoRouteArgs{key: $key, cardColor: $cardColor, formFactor: $formFactor, walletAddress: $walletAddress, isOriginalTag: $isOriginalTag, tagId: $tagId, recordsLength: $recordsLength, isExistsInDb: $isExistsInDb, barcodeIdFromDb: $barcodeIdFromDb, serialNumber: $serialNumber}';
  }
}

/// generated route for
/// [_i2.Dashboard]
class Dashboard extends _i3.PageRouteInfo<void> {
  const Dashboard({List<_i3.PageRouteInfo>? children})
      : super(
          Dashboard.name,
          initialChildren: children,
        );

  static const String name = 'Dashboard';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

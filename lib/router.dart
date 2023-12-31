import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

export 'router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page|Screen,Route',
)
class Router extends $Router {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    AdaptiveRoute(
      page: Dashboard.page,
      fullscreenDialog: true,
      initial: true,
    ),
    AdaptiveRoute(
      page: CardInfoRoute.page,
    ),
  ];
}

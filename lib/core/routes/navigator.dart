import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

Future pushTo(BuildContext context, String route, {Object? extra}) {
  return context.push(route, extra: extra);
}

pushReplacementTo(BuildContext context, String route, {Object? extra}) {
  return context.pushReplacement(route, extra: extra);
}

pop(BuildContext context) {
  return context.pop();
}

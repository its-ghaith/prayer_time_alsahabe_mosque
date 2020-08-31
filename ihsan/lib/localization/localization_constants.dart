import 'package:Ihsan/localization/demo_localization.dart';
import 'package:flutter/material.dart';

String getTrabskated(BuildContext context, String key){
  return DemoLocalization.of(context).getTranslatedValue(key);
}
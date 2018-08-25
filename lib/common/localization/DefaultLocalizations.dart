import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xc_deploy_app/common/style/GSYStringBase.dart';
import 'package:xc_deploy_app/common/style/GSYStringEn.dart';
import 'package:xc_deploy_app/common/style/GSYStringZh.dart';

///自定义多语言实现
class GSYLocalizations {
  final Locale locale;

  GSYLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///GSYStringEn和GSYStringZh都继承了GSYStringBase
  static Map<String, GSYStringBase> _localizedValues = {
    'en': new GSYStringEn(),
    'zh': new GSYStringZh(),
  };

  GSYStringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 GSYStringBase
  static GSYLocalizations of(BuildContext context) {
    return Localizations.of(context, GSYLocalizations);
  }
}

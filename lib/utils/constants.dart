import 'package:flutter/material.dart';

/// アプリ全体で使用する定数
class AppConstants {
  // アプリ名
  static const String appName = 'English Linking & Reduction';
  
  // カラー
  static const Color primaryColor = Color(0xFF3F51B5); // インディゴ
  static const Color accentColor = Color(0xFFFF4081); // ピンク
  static const Color backgroundColor = Color(0xFFF5F5F5); // ライトグレー
  static const Color textColor = Color(0xFF212121); // ダークグレー
  static const Color disabledColor = Color(0xFFBDBDBD); // グレー
  
  // テキストスタイル
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
  
  // アニメーション
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // パディング
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // ボーダーラディウス
  static const double defaultBorderRadius = 8.0;
  
  // エレベーション
  static const double defaultElevation = 2.0;
}

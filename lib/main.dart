import 'package:flutter/material.dart';
import 'package:currency_converter_app/theme/style.dart';
import 'package:currency_converter_app/screens/home.dart';

Future<void> main()  {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: appTheme(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

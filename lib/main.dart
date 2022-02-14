import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:precious_tv/pages/home.dart';
import 'package:precious_tv/pages/splash.dart';
import 'package:wakelock/wakelock.dart';
import 'configs/size_config.dart';

/*class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}*/

Future main() async {
  //HttpOverrides.global = new MyHttpOverrides();
  Wakelock.enable();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,

  ));
  runApp(

      LayoutBuilder(   // Add LayoutBuilder
          builder: (context, constraints) {
            return OrientationBuilder(   // Add OrientationBuilder
                builder: (context, orientation) {
                  SizeConfi().init(constraints, orientation); // SizeConfig initialization

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: '',
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en', ''), // English
                      Locale('fr', ''), // french
                    ],
                    theme: ThemeData(
                      primaryColor: Colors.blue[800],
                      accentColor: Colors.blue,
                      // Define the default font family.
                      fontFamily: 'Poppins Light',
                      pageTransitionsTheme: const PageTransitionsTheme(builders: {
                        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      }),
                    ),
                    home: SplashScreen(),
                  );
                }
            );
          }
      )

  );
}



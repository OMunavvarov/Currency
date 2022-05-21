import 'package:currency/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main(){
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (_)=>MainViewModel(),
        )
      ],child: MyApp(),
      ));

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

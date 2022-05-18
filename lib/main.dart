import 'package:flutter/material.dart';
import 'package:infinte_scroll/base_infinite_scroll/post_overview_screen.dart';
import 'package:infinte_scroll/infinte_sroll_paginator/infinite_scroll_paginator.dart';
import 'package:infinte_scroll/scroll_controller_demo/scroll_controller_infinite_sroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfiniteScrollPaginatorDemo()
    );
  }
}

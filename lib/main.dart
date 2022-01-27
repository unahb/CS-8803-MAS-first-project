// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),
      home: LoginPage(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     title: 'Random Meme Viewer',
  //     home: RandomMemes(),
  //   );
  // }
}

class RandomMemes extends StatefulWidget {
  const RandomMemes({Key? key}) : super(key: key);

  @override
  _RandomMemesState createState() => _RandomMemesState();
}

class _RandomMemesState extends State<RandomMemes> {
  List<String> memes = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Memes"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        controller: _scrollController,
        itemCount: memes.length,
        itemBuilder: (context, index) {
          return Container(
            // constraints: BoxConstraints.tightFor(
            //   height: 150.0,
            // ),
            child: Image.network(memes[index], fit: BoxFit.fitWidth),
          );
        },
      ),
    );
  }

  fetch() async {
    Map<String, String>? requestHeaders = {
      "Access-Control-Allow-Origin": "*",
    };

    final response = await http.get(
        Uri.parse('https://meme-api.herokuapp.com/gimme/wholesomememes/5'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        for (int i = 0; i < 5; i++) {
          memes.add(jsonDecode(response.body)['memes'][i]['url']);
        }
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load meme');
    }
  }
}

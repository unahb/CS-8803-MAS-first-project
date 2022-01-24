// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: 'Random Meme Viewer',
      home: RandomMemes(),
    );
  }
}

class RandomMemes extends StatefulWidget {
  const RandomMemes({Key? key}) : super(key: key);

  @override
  _RandomMemesState createState() => _RandomMemesState();
}

class _RandomMemesState extends State<RandomMemes> {
  // final _suggestions = <WordPair>[];
  final _memes = <Meme>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Future<Widget> _buildSuggestions() async{
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _memes.length) {
            for (var i = 0; i < 10; i++) {
              Meme temp = await fetchMemes();
              _memes.add(temp);
            }
          }
          return _buildRow(_memes[index]);
        });
  }

  Widget _buildRow(Meme meme) {
    return ListTile(
      title: Text(
        meme.title,
        style: _biggerFont,
      ),
      leading: Image.network(
        meme.url,
        width: 100,
        height: 100,
      ),
    );
  }

  @override
  Future<Widget> build(BuildContext context) async{
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme Viewer'),
      ),
      body: await _buildSuggestions(),
    );
  }
}

const String url = 'https://meme-api.herokuapp.com/gimme/wholesomememes';

class Meme {
  final String url;
  final String title;

  const Meme({required this.url, required this.title});

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(url: json['url'] as String, title: json['title'] as String);
  }
}

Future<Meme> fetchMemes() async {
  final response = await http
      .get(Uri.parse('https://meme-api.herokuapp.com/gimme/wholesomememes/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Meme.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load meme');
  }
}

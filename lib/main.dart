import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(TextTranslatorApp());
}

class TextTranslatorApp extends StatefulWidget {
  @override
  State<TextTranslatorApp> createState() => _TextTranslatorAppState();
}

class _TextTranslatorAppState extends State<TextTranslatorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslatorPage(),
    );
  }
}

class TranslatorPage extends StatefulWidget {
  @override
  _TranslatorPageState createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  String _selectedLanguage = 'en'; // Default language is English
  List<dynamic> post = [];
  List<String> translatedTexts = [];
  List<String> translatedTexts2 = [];

  Future<void> jsondata() async {
    final response =
    await get(Uri.parse("https://raw.githubusercontent.com/techlab33/nubtk/main/test_json"));
    if (response.statusCode == 200) {
      setState(() {
        post = json.decode(response.body);
        translatedTexts = List.generate(post.length, (index) => post[index]['name']);
        translatedTexts2 = List.generate(post.length, (index) => post[index]['des']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    jsondata();
  }

  Future<void> _translateText(String toLanguage) async {
    GoogleTranslator translator = GoogleTranslator();

    for (int i = 0; i < post.length; i++) {
      var nameTranslation = await translator.translate(post[i]['name'], to: toLanguage);
      translatedTexts[i] = nameTranslation.toString();

      var desTranslation = await translator.translate(post[i]['des'], to: toLanguage);
      translatedTexts2[i] = desTranslation.toString();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Translator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                    _translateText(newValue);
                  });
                }
              },
              items: <String>['en', 'es', 'bn', 'fr', 'de']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ...List.generate(post.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(
                      translatedTexts[index],
                      style: TextStyle(fontSize: 18.0),
                  ),

                   Text(
                      translatedTexts2[index],
                      style: TextStyle(fontSize: 18.0),
                    ),

                  SizedBox(height: 20.0),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
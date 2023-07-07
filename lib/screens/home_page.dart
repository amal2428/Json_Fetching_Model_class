import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_model_class/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:json_model_class/model/response_model/response_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? movieTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("json fetching model class"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(movieTitle ?? 'Click the button to fetch data'),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: const Icon(
                Icons.done_outline_sharp,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(pathUrl));

      if (response.statusCode == 200 || response.statusCode == 201) {
        String jsonString = response.body;
        Map<String, dynamic> jsonDataMap = jsonDecode(jsonString);

        ResponseModel jsonDataObject = ResponseModel.fromJson(jsonDataMap);

        setState(() {
          int arrayLength =
              jsonDataObject.results.length; // length of results array
          int randomNumber = Random().nextInt(arrayLength);
          // maximum value for number generation = length of array

          movieTitle = jsonDataObject.results[randomNumber].originalTitle;
        });
      } else {
        print('server side error');
      }
    } catch (error) {
      print("client side error");
    }
  }
}

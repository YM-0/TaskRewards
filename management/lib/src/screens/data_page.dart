import 'package:flutter/material.dart';
import 'package:management/main.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DataPage"),
      ),
      body: Container(
        alignment: Alignment(0.0, 0.0),
        child: const Text(
          "DataPage",
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}

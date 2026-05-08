import 'package:flutter/material.dart';
import 'package:meu_app/widgets/button.widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora')),
      body: Column(
        children: [
          Container(
            height: 200, 
            width: double.maxFinite, 
            color: Colors.black12,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "0", 
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ButtonWidget(
                    color: Colors.red,
                    text: "C",
                    onPressed: () {},
                  ),
                  ButtonWidget(
                    color: Colors.orange,
                    text: "\u232B",
                    onPressed: (){},
                  ),
                  ButtonWidget(
                    text: "÷",
                    color: Colors.blue,
                    onPressed: (){},
                  ),
                ],
              ),
            Row(
              children: [
                  ButtonWidget(text: "7", onPressed: () {}),
                  ButtonWidget(text: "8", onPressed: () {}),
                  ButtonWidget(text: "9", onPressed: () {}),
                  ButtonWidget(text: "x", onPressed: () {}, color: Colors.blue, textColor: Colors.white,),
                ]
            ),
            Row(
              children: [
                  ButtonWidget(text: "4", onPressed: () {}),
                  ButtonWidget(text: "5", onPressed: () {}),
                  ButtonWidget(text: "6", onPressed: () {}),
                  ButtonWidget(text: "-", onPressed: () {}, color: Colors.blue, textColor: Colors.white),
                ]
            ),
            Row(
              children: [
                  ButtonWidget(text: "1", onPressed: () {}),
                  ButtonWidget(text: "2", onPressed: () {}),
                  ButtonWidget(text: "3", onPressed: () {}),
                  ButtonWidget(text: "+", onPressed: () {}, color: Colors.blue, textColor: Colors.white),
                ]
            ),
            Row(
              children: [
                  ButtonWidget(text: "0", onPressed: () {}),
                  ButtonWidget(text: ",", onPressed: () {}),
                  ButtonWidget(text: "=", onPressed: () {}, color: Colors.green,),
                ]
            ),
          ]
          )
        ],
      ),
    );
  }
}
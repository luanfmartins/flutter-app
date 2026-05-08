import 'package:flutter/material.dart';
import 'package:meu_app/enums/operation.type.dart';
import 'package:meu_app/widgets/button.widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayNumber;
  OperationTypeEnum? operationType;

  @override
  void initState() {
    displayNumber = "00";
    super.initState();
  }

  void clear() {
    setState(() {
      displayNumber = "0";
      operationType = null;
    });
  }

  void setOperationType(OperationTypeEnum newType) {
    setState(() {
      operationType = newType;
      displayNumber += newType.symbol;
    });
  }

  void appendNumber(String stringNumber) {
    setState(() {
      if (stringNumber == "," && displayNumber.contains(',')) {
        return;
      }
      if (displayNumber == "0") {
        if (stringNumber == ",") {
          displayNumber += stringNumber;
          return;
        }
        displayNumber = stringNumber;
        return;
      }
      displayNumber += stringNumber;
    });
  }

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
                displayNumber,
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
                    onPressed: () {
                      clear();
                    },
                  ),
                  ButtonWidget(
                    color: Colors.orange,
                    text: "\u232B",
                    onPressed: () {},
                  ),
                  ButtonWidget(
                    text: "÷",
                    color: Colors.blue,
                    onPressed: () {
                      setOperationType(OperationTypeEnum.division);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "7",
                    onPressed: () {
                      appendNumber("7");
                    },
                  ),
                  ButtonWidget(
                    text: "8",
                    onPressed: () {
                      appendNumber("8");
                    },
                  ),
                  ButtonWidget(
                    text: "9",
                    onPressed: () {
                      appendNumber("9");
                    },
                  ),
                  ButtonWidget(
                    text: "x",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.multiplication);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "4",
                    onPressed: () {
                      appendNumber("4");
                    },
                  ),
                  ButtonWidget(
                    text: "5",
                    onPressed: () {
                      appendNumber("5");
                    },
                  ),
                  ButtonWidget(
                    text: "6",
                    onPressed: () {
                      appendNumber("6");
                    },
                  ),
                  ButtonWidget(
                    text: "-",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.subtraction);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "1",
                    onPressed: () {
                      appendNumber("1");
                    },
                  ),
                  ButtonWidget(
                    text: "2",
                    onPressed: () {
                      appendNumber("2");
                    },
                  ),
                  ButtonWidget(
                    text: "3",
                    onPressed: () {
                      appendNumber("3");
                    },
                  ),
                  ButtonWidget(
                    text: "+",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.addition);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "0",
                    onPressed: () {
                      appendNumber("0");
                    },
                  ),
                  ButtonWidget(
                    text: ",",
                    onPressed: () {
                      appendNumber(",");
                    },
                  ),
                  ButtonWidget(
                    text: "=",
                    onPressed: () {},
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

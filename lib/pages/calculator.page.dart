import 'dart:developer';

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
    displayNumber = "0";
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

  List<double> parseNumbers(String expression) {
    RegExp regExp = RegExp(r'[0-9]+\.?[0-9]*');

    var matches = regExp.allMatches(expression);

    List<double> numbers = [];
    for (var match in matches) {
      String numberText = match.group(0)!;
      numbers.add(double.parse(numberText));
    }

    return numbers;
  }

  List<OperationTypeEnum> getOperators(String expression) {
    final expression1 = expression.characters.where(
      (x) => OperationTypeEnum.values.any((op) => op.symbol == x),
    );

    var exp = expression1
        .map((x) => OperationTypeEnum.values.firstWhere((op) => op.symbol == x))
        .toList();

    return exp;
  }

  void calculate() {
    String expression = displayNumber.replaceAll(',', '.');
    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);
    resolvePriorityOperations(numbers, operations);
    resolveAdditionSubtraction(numbers, operations);
    final result = numbers[0];
    setState(() {
      displayNumber = result.toString().replaceAll(',', '.');
    });
  }

  void resolvePriorityOperations(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;
    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.multiplication) {
        numbers[index] = numbers[index] * numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationTypeEnum.division) {
        numbers[index] = numbers[index] / numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }
  }

  void resolveAdditionSubtraction(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;
    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.subtraction) {
        numbers[index] = numbers[index] - numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationTypeEnum.addition) {
        numbers[index] = numbers[index] + numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }
  }

  void backspaceNumber() {
    setState(() {
      if (displayNumber.length > 1 && displayNumber.isNotEmpty) {
        displayNumber = displayNumber.substring(0, displayNumber.length - 1);
      } else {
        displayNumber = "0";
      }
    });
  }

  void appendOperator(String stringNumber) {
    setState(() {
      RegExp rgx = RegExp(r'[0-9]+\.?[0-9]*');
      var matches = rgx.allMatches(displayNumber);
      List<String> numbers = matches.map((m) => m.group(0)!).toList();
      List<OperationTypeEnum> operators = OperationTypeEnum.values;

      // if (operators.any(numbers.last) != "") {
      //   return;
      // }
    });
  }

  void appendNumber(String stringNumber) {
    setState(() {
      if (stringNumber == ",") {
        RegExp rgx = RegExp(r'\d+(?:,\d*)?');
        var matches = rgx.allMatches(displayNumber);
        List<String> numbers = matches.map((m) => m.group(0)!).toList();

        if (numbers.last.contains(',')) {
          return;
        }
        displayNumber += stringNumber;
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Calculadora'),
        leading: Icon(Icons.calculate),
      ),
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
                    onPressed: () {
                      backspaceNumber();
                    },
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
                    onPressed: () {
                      calculate();
                    },
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meu_app/enums/operation.type.dart';
import 'package:meu_app/pages/history.page.dart';
import 'package:meu_app/widgets/button.widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayNumber;
  OperationTypeEnum? operationType;
  late List<String> history;
  late bool freshCalcFlag = false;
  late String lastOperator;

  @override
  void initState() {
    displayNumber = "0";
    history = [];
    super.initState();
  }

  void clear() {
    setState(() {
      displayNumber = "0";
      operationType = null;
      freshCalcFlag = false;
    });
  }

  void clearHistory() {
    setState(() {
      history.clear();
    });
  }

  void setOperationType(OperationTypeEnum newType) {
    setState(() {
      freshCalcFlag = false;
      operationType = newType;
      if (OperationTypeEnum.values.any(
            (op) => op.symbol == displayNumber.characters.last,
          ) ||
          displayNumber == "Não é possível dividir por zero" ||
          displayNumber.characters.last == ",") {
        displayNumber = displayNumber.replaceRange(
          displayNumber.length - 1,
          null,
          newType.symbol,
        );
        return;
      }

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

    if (expression[0] == OperationTypeEnum.subtraction.symbol) {
      numbers.first *= -1;
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

    if (expression[0] == OperationTypeEnum.subtraction.symbol) {
      exp.remove(OperationTypeEnum.subtraction);
    }
    return exp;
  }

  double executeOperation(double a, double b, String op) {
    switch (op) {
      case "+":
        return a + b;

      case "-":
        return a - b;

      case "×":
        return a * b;

      case "÷":
        if (b == 0) {
          throw Exception("Divisão por zero");
        }

        return a / b;

      default:
        return b;
    }
  }

  void calculate() {
    String expression = displayNumber.replaceAll(',', '.');
    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);
    String result;

    // quando clica no IGUAL(=) após uma operação ter sido feita
    // pega a ultima expressao e repete a ultima operação com o current result
    if (numbers.length <= 1) {
      if (!freshCalcFlag) {
        return;
      }
      RegExp lastRegexOp = RegExp(r'[+\-x÷]\d+(?:[.,]\d+)?(?=\s*=)');

      var lastExpression = lastRegexOp.allMatches(history.last);

      for (var match in lastExpression) {
        lastOperator = match.group(0)!;
      }

      var lastMatch = displayNumber + lastOperator.replaceAll(',', '.');

      var lastNumbers = parseNumbers(lastMatch);
      var lastOperation = getOperators(lastMatch);

      resolvePriorityOperations(lastNumbers, lastOperation);
      resolveAdditionSubtraction(lastNumbers, lastOperation);

      result = lastNumbers[0].toString();
      expression += lastOperator;
    } else {
      try {
        resolvePriorityOperations(numbers, operations);
        resolveAdditionSubtraction(numbers, operations);
        result = numbers[0].toString();
      } on FormatException catch (e) {
        result = e.message;
      }
    }

    setState(() {
      displayNumber = result;
      history.add("$expression = $result");
      freshCalcFlag = true;
      lastOperator = lastOperator;
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
        if (numbers[index + 1] == 0) {
          throw FormatException("Não é possível dividir por zero");
        }
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
      if (displayNumber.length > 1 &&
          displayNumber.isNotEmpty &&
          displayNumber != "Não é possível dividir por zero") {
        displayNumber = displayNumber.substring(0, displayNumber.length - 1);
      } else {
        displayNumber = "0";
      }
    });
  }

  void appendComma() {
    setState(() {
      RegExp rgx = RegExp(r'\d+(?:,\d*)?');
      var matches = rgx.allMatches(displayNumber);
      List<String> numbers = matches.map((m) => m.group(0)!).toList();

      if (isOperator(displayNumber.characters.last) ||
          isComma(displayNumber.characters.last) ||
          numbers.last.contains(',')) {
        return;
      }

      if (freshCalcFlag) {
        displayNumber = "0,";
        return;
      }

      displayNumber += ",";
    });
  }

  bool isComma(String char) {
    return char == ",";
  }

  bool isOperator(String char) {
    return OperationTypeEnum.values.any((op) => op.symbol == char);
  }

  void appendNumber(String stringNumber) {
    setState(() {
      if (displayNumber == "Não é possível dividir por zero") {
        displayNumber = stringNumber;
        freshCalcFlag = false;
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

      if (freshCalcFlag) {
        displayNumber = stringNumber;
        freshCalcFlag = false;
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HistoryPage(history: history, onClear: clearHistory),
                ),
              );
            },
            icon: Icon(Icons.history),
          ),
        ],
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
                    textColor: Colors.white,
                    text: "C",
                    onPressed: () {
                      clear();
                    },
                  ),
                  ButtonWidget(
                    color: Colors.orange,
                    textColor: Colors.white,
                    text: "\u232B",
                    onPressed: () {
                      backspaceNumber();
                    },
                  ),
                  ButtonWidget(
                    text: "÷",
                    textColor: Colors.white,
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
                      appendComma();
                    },
                  ),
                  ButtonWidget(
                    text: "=",
                    onPressed: () {
                      calculate();
                    },
                    textColor: Colors.white,
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

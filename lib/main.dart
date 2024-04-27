import 'package:app2/colors.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'dart:math' as math;

// Calculate a color with a given opacity
Color colorWithOpacity(Color color, double opacity) {
  return color.withOpacity(opacity);
}

void main() {
  runApp(const MaterialApp(
    home: CalculatorApp(),
  ));
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  //variables
  double firstNum = 0.0;
  double secondNum = 0.0;
  var input = '';
  var output = '';
  var operation = '';
  var hideInput = false;
  var outputSize = 34.0;

  //method create operation
  void onButtonClick(value) {
    if (value == "AC") {
      input = '';
      output = '';
    } else if (value == "C") {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        try {
          var processedInput = input.replaceAll("log", "log10");
          processedInput = processedInput.replaceAllMapped(
              RegExp(r'π(\d)'), (match) => 'π*${match.group(1)}');
          processedInput = processedInput.replaceAll("π", math.pi.toString());
          processedInput = processedInput.replaceAll("x", "*");
          processedInput = processedInput.replaceAll("√", "sqrt");
          if (_hasIncompleteExpression(processedInput)) {
            processedInput += ')';
          }
          Parser p = Parser();
          Expression expression = p.parse(processedInput);
          ContextModel cm = ContextModel();
          var finalValue = expression.evaluate(EvaluationType.REAL, cm);
          output = finalValue.toString();
          if (output.endsWith(".0")) {
            output = output.substring(0, output.length - 2);
          }
          input = output;
          hideInput = true;
          outputSize = 52;
        } catch (e) {
          output = 'Error: Invalid expression';
          input = '';
        }
      }
    } else if (value == "sin" || value == "cos" || value == "tan") {
      input += value + '(';
      hideInput = false;
      outputSize = 34;
    } else if (value == "√") {
      input += '√(';
      hideInput = false;
      outputSize = 34;
    } else if (value == "π") {
      input += "π";
      hideInput = false;
      outputSize = 34;
    } else if (value == "x²") {
      input += '^2';
      hideInput = false;
      outputSize = 34;
    } else if (value == "log") {
      input += 'log(';
      hideInput = false;
      outputSize = 34;
    } else if (value == "%") {
      // Perform percentage calculation
      input = (double.parse(input) / 100).toString();
      output = input;
      hideInput = true;
      outputSize = 52;
    } else {
      input = input + value;
      hideInput = false;
      outputSize = 34;
    }

    setState(() {});
  }

  bool _hasIncompleteExpression(String expression) {
    int openParenthesesCount = expression.split('(').length - 1;
    int closeParenthesesCount = expression.split(')').length - 1;
    return openParenthesesCount > closeParenthesesCount;
  }

  @override
  Widget build(BuildContext context) {
    //ui design
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //input output area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideInput ? '' : input,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                      fontSize: outputSize,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),

          //button area
          Row(
            children: [
              button(
                  text: "(", buttonBgColor: operatorColor, tColor: orangeColor),
              button(
                  text: ")", buttonBgColor: operatorColor, tColor: orangeColor),
              button(
                  text: "√", buttonBgColor: operatorColor, tColor: orangeColor),
              button(
                  text: "x²",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(
                  text: "sin",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
              button(
                  text: "cos",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
              button(
                  text: "tan",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
              button(
                  text: "π", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(
                  text: "AC",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
              button(
                  text: "C", buttonBgColor: operatorColor, tColor: orangeColor),
              button(
                  text: "log",
                  buttonBgColor: operatorColor,
                  tColor: orangeColor),
              button(
                  text: "/", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(
                  text: "x", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(
                  text: "-", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(
                  text: "+", buttonBgColor: operatorColor, tColor: orangeColor),
            ],
          ),
          Row(
            children: [
              button(
                  text: "%", buttonBgColor: operatorColor, tColor: orangeColor),
              button(text: "0"),
              button(text: "."),
              button(text: "=", buttonBgColor: orangeColor),
            ],
          ),
        ],
      ),
    );
  }

//button widget function create
  Widget button({
    text,
    tColor = Colors.white,
    Color buttonBgColor = const Color(0xff191919), // Default color added
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(22),
            backgroundColor: buttonBgColor,
          ),
          onPressed: () => onButtonClick(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: tColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

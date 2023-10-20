import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '';
  double result = 0.0;
  String currentNumber = '';
  String operator = '';
  bool operatorClicked = false;

  void handleButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        display = '';
        result = 0.0;
        currentNumber = '';
        operator = '';
        operatorClicked = false;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "x" ||
          buttonText == "/") {
        if (operatorClicked) {
          return;
        }
        operatorClicked = true;
        operator = buttonText;
        display += buttonText;
      } else if (buttonText == "=") {
        if (currentNumber.isEmpty || operator.isEmpty) {
          return;
        }
        double num1 = double.parse(currentNumber);
        double num2 = double.parse(display.split(operator).last);
        switch (operator) {
          case "+":
            result = num1 + num2;
            break;
          case "-":
            result = num1 - num2;
            break;
          case "x":
            result = num1 * num2;
            break;
          case "/":
            result = num1 / num2;
            break;
        }
        display = result.toString();
        currentNumber = display;
        operator = '';
      } else {
        currentNumber += buttonText;
        display += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText, {Color color = Colors.grey}) {
    return Expanded(
      child: OutlineButton(
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          handleButtonPressed(buttonText);
        },
        color: color,
        padding: EdgeInsets.all(24.0),
        borderSide: BorderSide(
          width: 2.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              display,
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/"),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("x"),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("C", color: Colors.redAccent),
                  buildButton("0"),
                  buildButton("="),
                  buildButton("+"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

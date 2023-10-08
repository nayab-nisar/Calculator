import 'package:calculator/UI and logic/hide.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // intializing the variables
  double firstnumber = 0.0;
  double secondnumber = 0.0;
  var input = "";
  var output = "";
  var operation = "";
  var hideinp = false;
  var outputsize = 36.0;
  Color textcolor = Colors.white.withOpacity(0.7);

  

  onButtonclick(value) {
    if (value == "AC") {
      input = "";
      output = "";
    } else if (value == "mc") {
    } else if (value == "<") {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        if (input == "11+11") {
          setState(() {
            
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Hide()));
          });
        } else {
          var userinput = input;
          userinput = input.replaceAll("x", "*");
          Parser p = Parser();
          Expression exp = p.parse(userinput);
          ContextModel contmodel = ContextModel();
          var finalvalue = exp.evaluate(EvaluationType.REAL, contmodel);
          output = finalvalue.toString();
          if (output.endsWith(".0")) {
            output = output.substring(0, output.length - 2);
          }
          input = output;
          hideinp = true;
          outputsize = 50.0;
          textcolor = Colors.white.withOpacity(1);
        }
      }
    } else if (value == "%") {
      // Handle percentage calculation
      if (input.isNotEmpty) {
        // Parse the input to a double
        double inputNumber = double.tryParse(input) ?? 0.0;
        // Calculate the percentage (88% as 0.88)
        double result = inputNumber * 0.01;
        // Update the input and output
        input = result.toString();
        output = input;
      }
    } else {
      input = input + value;
      hideinp = false;
      outputsize = 36.0;
      textcolor = Colors.white.withOpacity(0.75);
    }
    setState(() {});
  }

  void _handlePopupMenuSelection(String value) {
    // Handle the selected menu item here
    if (value == 'Option 1') {
      // Do something for Option 1
    } else if (value == 'Option 2') {
      // Do something for Option 2
    }
    // Add more cases for each menu item as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 43, 42, 42),
          // title: const Text('Calculator'),
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              onSelected: _handlePopupMenuSelection,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Option 1',
                    child: Row(
                      children: [
                        Text(
                          "Forget password",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Option 2',
                    child: Icon(Icons.light_mode),
                  ),
                  // Add more PopupMenuItem widgets for additional options
                ];
              },
            ),
            const Icon(Icons.settings)
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hideinp ? "" : input, //false "", true input
                      style: const TextStyle(
                        fontSize: 46,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      output,
                      style: TextStyle(
                        fontSize: outputsize,
                        color: textcolor,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                button(
                    buttontext: "AC",
                    callback: () {},
                    fgcolor: const Color.fromARGB(255, 255, 132, 0),
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
                button(
                    buttontext: "<",
                    callback: () {},
                    fgcolor: const Color.fromARGB(255, 255, 132, 0),
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
                button(
                    buttontext: "mc",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
                button(
                    buttontext: "/",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
              ],
            ),
            Row(
              children: [
                button(buttontext: "7", callback: () {}),
                button(buttontext: "8", callback: () {}),
                button(buttontext: "9", callback: () {}),
                button(
                    buttontext: "x",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
              ],
            ),
            Row(
              children: [
                button(buttontext: "4", callback: () {}),
                button(buttontext: "5", callback: () {}),
                button(buttontext: "6", callback: () {}),
                button(
                    buttontext: "-",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
              ],
            ),
            Row(
              children: [
                button(buttontext: "1", callback: () {}),
                button(buttontext: "2", callback: () {}),
                button(buttontext: "3", callback: () {}),
                button(
                    buttontext: "+",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 68, 67, 67)),
              ],
            ),
            Row(
              children: [
                button(buttontext: "%", callback: () {}),
                button(buttontext: "0", callback: () {}),
                button(buttontext: ".", callback: () {}),
                button(
                    buttontext: "=",
                    callback: () {},
                    bgcolor: const Color.fromARGB(255, 255, 173, 49)),
              ],
            ),
          ],
        ));
  }

//creating the button
  Widget button({
    Color? bgcolor,
    Color? fgcolor,
    required String? buttontext,
    required VoidCallback? callback,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgcolor ?? const Color.fromARGB(255, 47, 30, 30),
            padding: const EdgeInsets.all(22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Use an anonymous function to pass the onButtonclick function with buttontext
            onButtonclick(buttontext);
          },
          child: Text(
            buttontext!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: fgcolor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

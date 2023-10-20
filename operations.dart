class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "";
  String result = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "";
        result = "";
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          result = "Error";
        }
      } else {
        equation += buttonText;
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Text(
                equation,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Text(
                result,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: buildButton("7", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("8", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("9", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("/", 1, Colors.orange),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildButton("4", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("5", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("6", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("x", 1, Colors.orange),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildButton("1", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("2", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("3", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("-", 1, Colors.orange),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: buildButton("C", 1, Colors.red),
              ),
              Expanded(
                child: buildButton("0", 1, Colors.grey),
              ),
              Expanded(
                child: buildButton("=", 1, Colors.blue),
              ),
              Expanded(
                child: buildButton("+", 1, Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

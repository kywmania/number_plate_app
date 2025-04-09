import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  final List<String> keypadValues = [
    '+',
    '-',
    '*',
    '/',
    '1',
    '2',
    '3',
    '^',
    '4',
    '5',
    '6',
    '()',
  ];

  final Set<String> usedButtons = {};
  final List<String> expression = [];
  bool nextBracketIsOpen = true; // 괄호 번갈아 입력 플래그
  final int targetNumber = Random().nextInt(900) + 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NumberPlate')),
      body: Column(
        children: [
          _buildNumberPlate(),
          _buildExpressionBox(),
          const SizedBox(height: 20),
          _buildControlButtons(),
          const SizedBox(height: 10),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildNumberPlate() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(
        '$targetNumber',
        style: const TextStyle(fontSize: 150, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExpressionBox() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade900, width: 10),
          color: Colors.white,
        ),
        child: Text(expression.join(''), style: const TextStyle(fontSize: 30)),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          label: 'RESET',
          color: Colors.red,
          onPressed: () {
            setState(() {
              usedButtons.clear();
              expression.clear();
              nextBracketIsOpen = true;
            });
          },
        ),
        const SizedBox(width: 10),
        _buildButton(
          label: 'CHECK',
          color: Colors.green,
          onPressed: _evaluateExpression,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 170,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildKeypad() {
    return SizedBox(
      width: 350,
      height: 300,
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
        crossAxisCount: 4,
        children:
            keypadValues.map((value) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !usedButtons.contains(value)
                          ? Colors.teal[400]
                          : Colors.grey,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  _onKeypadPressed(value);
                },
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _onKeypadPressed(String value) {
    setState(() {
      if (value == '()') {
        if (!usedButtons.contains('(') || !usedButtons.contains(')')) {
          final bracket = nextBracketIsOpen ? '(' : ')';
          expression.add(bracket);
          usedButtons.add(bracket);
          if (!nextBracketIsOpen) usedButtons.add('()');
          nextBracketIsOpen = !nextBracketIsOpen;
        }
      } else if (!usedButtons.contains(value)) {
        expression.add(value);
        usedButtons.add(value);
      }
    });
  }

  void _evaluateExpression() {
    String expString = expression.join('');
    print("입력된 수식: $expString");

    // '^' 연산을 pow(...)로 치환 (괄호 포함)
    expString = expString.replaceAllMapped(
      RegExp(r'(\d+)\^(\d+|\(.+?\))'),
      (match) => "pow(${match.group(1)}, ${match.group(2)})",
    );

    try {
      final exp = Expression.parse(expString);
      final evaluator = const ExpressionEvaluator();

      int safePow(num base, num exponent) => pow(base, exponent).toInt();

      final result = evaluator.eval(exp, {'pow': safePow});
      print("결과: $result");

      if (result == targetNumber) {
        _showAutoDismissDialog(context, '정답');
      } else {
        _showAutoDismissDialog(context, '오답');
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  void _showAutoDismissDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 안 닫힘
      builder: (context) {
        // 1초 후 자동 닫기
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

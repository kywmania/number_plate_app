import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  List<String> arr = [
    '+',
    '-',
    '*',
    '÷',
    '1',
    '2',
    '3',
    '^',
    '4',
    '5',
    '6',
    '()',
  ];
  Set<String> usedButtons = {};

  int targetNumber = Random().nextInt(900) + 100;
  List<String> expression = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NumberPlate')),
      body: Column(
        children: [
          numberPlate(),
          expressionBox(expression),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      usedButtons.clear();
                      expression.clear();
                    });
                  },
                  child: Text('RESET', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(width: 30),
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    late int result;
                    String expressionString = expression.join('');
                    // 5^2 형태를 pow(5, 2)로 변환
                    expressionString = expressionString.replaceAllMapped(
                      RegExp(r'(\d+)\^(\d+)'),
                      (match) => "pow(${match.group(1)}, ${match.group(2)})",
                    );
                    try {
                      Expression exp = Expression.parse(expressionString);

                      final evaluator = const ExpressionEvaluator();
                      result = evaluator.eval(exp, {"pow": pow});
                    } catch (e) {
                      0;
                    }
                    print(result);
                    if (result == targetNumber) {
                      print('정답');
                    }
                  },
                  child: Text('CHECK', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          keyPads(),
        ],
      ),
    );
  }

  Widget numberPlate() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(
        '$targetNumber',
        style: TextStyle(fontSize: 150, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget expressionBox(List<String> expression) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text('${expression.join('')}', style: TextStyle(fontSize: 30)),
      ),
    );
  }

  Widget keyPads() {
    return Container(
      height: 350,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
      child: GridView.count(
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
        crossAxisCount: 4,
        children: List.generate(
          arr.length,
          (i) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              // 사용한 버튼 색 변경
              backgroundColor:
                  !usedButtons.contains(arr[i])
                      ? Colors.teal[400]
                      : Colors.grey,

              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              setState(() {
                if (!usedButtons.contains(arr[i])) {
                  expression.add(arr[i]);
                  usedButtons.add(arr[i]);
                }
              });
            },
            child: Text(
              arr[i],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

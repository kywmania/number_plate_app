import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePlayPage extends StatefulWidget {
  const GamePlayPage({super.key});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  final List<String> arr = [
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
  Set<String> usedButtons = {};
  List<String> expression = [];
  bool isOpenBracketNext = true; // 다음에 입력할 괄호가 여는 괄호인지 여부

  int targetNumber = Random().nextInt(900) + 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NumberPlate')),
      body: Column(
        children: [
          numberPlate(),
          expressionBox(expression),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
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
              SizedBox(width: 10),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    String expressionString = expression.join('');

                    print("입력된 수식: ${expression.join('')}");

                    // ^를 pow(...)로 변환
                    expressionString = expressionString.replaceAllMapped(
                      RegExp(r'(\d+)\^(\d+|\(.+?\))'), // 괄호 포함
                      (match) => "pow(${match.group(1)}, ${match.group(2)})",
                    );

                    try {
                      Expression exp = Expression.parse(expressionString);
                      final evaluator = const ExpressionEvaluator();

                      int safePow(num base, num exponent) =>
                          pow(base, exponent).toInt();

                      int result = evaluator.eval(exp, {"pow": safePow});

                      print("결과: $result");

                      if (result == targetNumber) {
                        print('정답');
                      } else {
                        print('틀림!');
                      }
                    } catch (e) {
                      print("에러 발생: $e");
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
      padding: EdgeInsets.only(top: 30),
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
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade900, width: 10),
          color: Colors.white,
        ),
        child: Text(expression.join(''), style: TextStyle(fontSize: 30)),
      ),
    );
  }

  Widget keyPads() {
    return Container(
      width: 350,
      height: 300,
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
                final value = arr[i];

                if (value == '()') {
                  if (!usedButtons.contains('(') ||
                      !usedButtons.contains(')')) {
                    // 괄호 번갈아 입력
                    String bracket = isOpenBracketNext ? '(' : ')';
                    expression.add(bracket);
                    usedButtons.add(bracket);

                    if (bracket == ')') {
                      usedButtons.add('()');
                    }
                    isOpenBracketNext = !isOpenBracketNext;
                  }
                } else {
                  if (!usedButtons.contains(value)) {
                    expression.add(value);
                    usedButtons.add(value);
                  }
                }
              });
            },
            child: Text(
              arr[i],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

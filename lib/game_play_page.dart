import 'package:flutter/material.dart';

class GamePlayPage extends StatelessWidget {
  GamePlayPage({super.key});

  final List<String> arr = ['+','-','x','÷','1','2','3','!','4','5','6','()'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NumberPlate'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
            
            ),
          ),
          Container(
            padding: EdgeInsets.all(40),
            height: 350,
            child: keyPads(),
          ),
        ],
      )
    );
  }

  Widget keyPads() {
    return GridView.count(
      mainAxisSpacing: 5,
      crossAxisSpacing: 10,
      crossAxisCount: 4,
      children: List.generate(
        arr.length,
        (i) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          ),
          onPressed: () {},
          child: Text(
            arr[i],
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}

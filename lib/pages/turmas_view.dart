import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TurmasView extends StatelessWidget {
  const TurmasView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                  child: Text('Turmas', style: TextStyle(fontSize: 40)))),
          SizedBox(height: 60),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                clipBehavior: Clip.none,
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text('Professor',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center),
                  padding: EdgeInsets.all(20)),
              Positioned(
                top:80,
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 50,),
                      Text('Nome')
                    ],
                  ),
                ),
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                clipBehavior: Clip.none,
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text('Alunos',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center),
                  padding: EdgeInsets.all(20)),
              Positioned(
                top:80,
                child: Container(
                  clipBehavior: Clip.none,
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(30, (index) {
                    return Column(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 50),
                      Text('Nome ${index}')
                    ]
                );
                })),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

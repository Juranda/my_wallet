import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/exercise_view.dart';
import 'package:my_wallet/app/home/trilhas/result_view.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView(this.initialSelectedIndex, this.atividades, {super.key});

  final List<Map<String, dynamic>> atividades;
  final int initialSelectedIndex;

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  final List<Widget> atividadesView = [];
  var selectedIndex = 0;

  void ChangeSelectedIndex(int newIndex) {
    setState(() {
      selectedIndex += newIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;

    for (int i = 0; i < widget.atividades.length; i++) {
      List<int> randomOrder = [0, 1, 2, 3];
      randomOrder.shuffle();
      atividadesView.add(ExerciseView(
        i,
        widget.atividades,
        ChangeSelectedIndex,
        randomOrder,
        key: Key(i.toString()),
      ));
    }
    atividadesView.add(ResultView(widget.atividades, ChangeSelectedIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: atividadesView[selectedIndex]);
  }
}

import 'package:flutter/material.dart';

class DeletarCadastroView extends StatelessWidget {
  DeletarCadastroView({super.key});
  final TextEditingController emailTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('Deletar Cadastro'),
          titleTextStyle: TextStyle(fontSize: 30, color: Colors.black),
        ),
        body: Center(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailTextController,
                  decoration: InputDecoration(
                    filled: true
                  ),
                ),
                ElevatedButton(
                  onPressed: (){}, 
                  child: Text("Deletar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
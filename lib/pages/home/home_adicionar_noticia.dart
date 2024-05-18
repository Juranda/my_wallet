import 'package:flutter/material.dart';
import 'package:my_wallet/components/aluno_perfil.dart';
import 'package:my_wallet/components/trail_lobby_news_card.dart';

final _formKey = GlobalKey<FormState>();
class AdicionarNoticia extends StatefulWidget {

  const AdicionarNoticia({super.key, required this.removerNoticia, required this.adicionarNoticia});

  final void Function(TrailLobbyNewsCard) removerNoticia;
  final void Function(TrailLobbyNewsCard) adicionarNoticia;
  @override
  State<AdicionarNoticia> createState() => _AdicionarNoticiaState();
}

class _AdicionarNoticiaState extends State<AdicionarNoticia> {
  
  final _newsNameController = TextEditingController();
  final _newsDescriptionController = TextEditingController();
  final _newsURLController = TextEditingController();
  List<Widget> noticias = [];

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 300,
      width: 150,
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _newsURLController,
                validator: (text){
                  if(text == null || text.isEmpty)
                  {
                    return '';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
                    labelText: 'URL',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                controller: _newsNameController,
                validator: (text){
                  if(text == null || text.isEmpty)
                  {
                    return '';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0), 
                    labelText: 'Nome',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                controller: _newsDescriptionController  ,
                validator: (text){
                  if(text == null || text.isEmpty)
                  {
                    return '';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0), 
                    labelText: 'Descrição',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.adicionarNoticia(
                          TrailLobbyNewsCard(
                        trailName: _newsNameController.text,
                        trailDescription: _newsDescriptionController.text,
                        removeCard: widget.removerNoticia,
                      ),);
                      Navigator.pop(context);
                    }
                    
                  },
                  child: Text('Adicionar'),
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ),

            ]),
          ),  
        ],
      ),
    );
  }
}

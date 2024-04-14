import 'package:flutter/material.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:provider/provider.dart';

class AlunoProfile extends StatelessWidget {
  AlunoProfile(this.myList,this.id,this.removeFromList);

  final List<AlunoProfile> myList;
  final void Function(AlunoProfile) removeFromList;
  final int id;
  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen:false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.account_circle_outlined, size: 50),
            Text('Nome do Aluno ${id}',
            style: Theme.of(context).textTheme.headlineSmall,),
          ],
        ),
        if (roleProvider.role == Role.professor) IconButton(onPressed: (){showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text('Remover aluno da turma?'),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(onPressed: (){print('alog');removeFromList(this);Navigator.pop(context);}, child: Text('Confirmar'),),
            TextButton(onPressed: ()=>Navigator.pop(context), child: Text('Cancelar'))
          ],
        ));}, icon: Icon(Icons.delete))
      ],
    );
  }
}
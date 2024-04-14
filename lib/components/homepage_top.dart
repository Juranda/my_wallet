import 'package:flutter/material.dart';

class HomePageViewTop extends StatelessWidget {
  const HomePageViewTop({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,0,10,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              
                        children: [
                          IconButton(
                            onPressed: ()=>Navigator.pushNamed(context, "/accountSettings"),
                            icon: Icon(
                              Icons.account_circle,
                              size: 40,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Seja bem-vinde Rodolfo!'),
                              Text('Turma 701'),
                            ],
                          ),
                           ],
                           ),Icon(Icons.settings,
                              size: 40,
                              color: Theme.of(context).colorScheme.secondary)
          ],
        ),
      ),
    );
             
  }
}
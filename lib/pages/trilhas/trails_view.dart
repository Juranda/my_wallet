import 'package:flutter/material.dart';

class TrailsView extends StatelessWidget {
  const TrailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ensino Fundamental',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,

            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Container(
          height: MediaQuery.of(context).size.height - 244,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              TrailItem(
                Trail(0, 'Cartao de Crédito', 'Uma trilha muito emocionan...',
                    false),
              ),
              TrailItem(
                Trail(0, 'Cartao de Crédito', 'Uma trilha muito emocionan...',
                    false),
              ),
              TrailItem(
                Trail(0, 'Cartao de Crédito', 'Uma trilha muito emocionan...',
                    true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrailItem extends StatelessWidget {
  final Trail trail;

  const TrailItem(this.trail, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;
    if (trail.completed) {
      color = color.withOpacity(0.5);
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/home/trails/trail', arguments: trail);
      },
      child: Container(
        color: color,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/cartao_credito.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          trail.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          trail.description,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    child: Icon(
                      trail.completed
                          ? Icons.check_rounded
                          : Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Trail {
  final int id;
  final String name;
  final String description;
  final bool completed;

  Trail(this.id, this.name, this.description, this.completed);
}

class TrailView extends StatelessWidget {
  const TrailView({super.key});

  @override
  Widget build(BuildContext context) {
    Trail trail = ModalRoute.of(context)!.settings.arguments as Trail;

    return Scaffold(
      body: Column(
        children: [
          Text(
            trail.name,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

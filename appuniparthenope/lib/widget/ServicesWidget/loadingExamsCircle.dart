import 'package:appuniparthenope/main.dart'; // Importa il file main.dart che contiene le costanti dei colori dell'app
import 'package:flutter/material.dart';

class ProgressCircleCounter extends StatefulWidget {
  final int totalCount; // Numero totale di conteggio
  final Duration duration; // Durata totale dell'animazione

  const ProgressCircleCounter({
    Key? key,
    required this.totalCount,
    required this.duration,
  }) : super(key: key);

  @override
  _ProgressCircleCounterState createState() => _ProgressCircleCounterState();
}

class _ProgressCircleCounterState extends State<ProgressCircleCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controller dell'animazione
  late Animation<double> _animation; // Animazione di riempimento del cerchio

  @override
  void initState() {
    super.initState();
    // Inizializza l'AnimationController con la durata fornita
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    // Crea un'animazione che va da 0 a 1
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    // Avvia l'animazione
    _animationController.forward();
  }

  @override
  void dispose() {
    // Disponi del controller dell'animazione
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Costruisci un cerchio di caricamento con un valore dinamico
        return Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: _animation.value, // Valore di riempimento del cerchio
            backgroundColor: Colors.transparent, // Colore di sfondo del cerchio
            valueColor: AlwaysStoppedAnimation<Color>(
              // Colore dinamico del cerchio in base al valore di riempimento
              _animation.value == 1
                  ? AppColors
                      .successColor // Colore verde se il caricamento è completo
                  : AppColors
                      .detailsColor, // Altrimenti usa il colore predefinito dell'app
            ),
            strokeWidth: 8, // Spessore del cerchio
          ),
        );
      },
    );
  }
}

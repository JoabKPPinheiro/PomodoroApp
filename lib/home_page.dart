import 'package:flutter/material.dart';
import 'package:pomodoro/pomodoro_controller.dart';

// scopo principal em que será criado a página inicial do aplicativo, que será exibida quando o aplicativo for iniciado.
//A classe HomePage é um StatefulWidget, o que significa que ela pode ter um estado mutável que pode ser alterado durante a execução do aplicativo.
//O método build é responsável por construir a interface do usuário da página inicial,
//que neste caso é um Scaffold com um corpo centralizado contendo um texto "Hello World!".

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PomodoroController _controller = PomodoroController();
  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Exemplo de como você pode montar o card de status dinâmico na sua Column:
            Builder(
              builder: (context) {
                String text;
                Color color;

                switch (_controller.currentMode) {
                  case PomodoroState.foco:
                    text =
                        'Foco (${_controller.completedFocusSessions + 1}º ciclo)';
                    color = const Color(0xFF800020); // Bordô
                    break;
                  case PomodoroState.pausa:
                    text = 'Pausa Curta ☕';
                    color = Colors.teal;
                    break;
                  case PomodoroState.descanso:
                    text = 'Pausa Longa 🌴';
                    color = Colors.indigo;
                    break;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value:
                          _controller.remainingSeconds /
                          PomodoroController
                              .focusTime, // Exemplo: 70% restante (depois usaremos uma variável aqui)
                      strokeWidth: 8,
                    ),
                  ),
                  Text(
                    _controller.formattedTime,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.isRunning) {
                        _controller.pause();
                      } else {
                        _controller.start(() {
                          setState(() {});
                        });
                      }
                    });
                  },
                  child: Text(_controller.isRunning ? 'Pausar' : 'Iniciar'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.reset(() {
                        setState(() {});
                      });
                    });
                  },
                  child: Text('Resetar'),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Pomodoro')),
    );
  }
}

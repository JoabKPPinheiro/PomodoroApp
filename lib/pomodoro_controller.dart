import 'dart:async';

enum PomodoroState { foco, pausa, descanso } //{focus, pause, break}

class PomodoroController {
  // Tempo padrão de 25 minutos em segundos
  static const int focusTime = 25;
  static const int breakTime = 5;
  static const int longBreakTime = 15;

  PomodoroState currentMode = PomodoroState.foco;
  int remainingSeconds = focusTime;
  Timer? _timer;
  bool isRunning = false;

  int completedFocusSessions = 0;

  void start(void Function() updateUI) {
    if (_timer != null) return;

    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        updateUI(); // Chama o setState da página
      } else {
        pause();
        _handleTimerCompletion(updateUI);
      }
    });
  }

  // Nova lógica para transição automática baseada nas regras do Pomodoro
  void _handleTimerCompletion(void Function() updateUI) {
    if (currentMode == PomodoroState.foco) {
      completedFocusSessions++;

      // A cada 4 ciclos de foco, a pausa é longa; senão, é curta
      if (completedFocusSessions % 4 == 0) {
        currentMode = PomodoroState.descanso;
        completedFocusSessions = 0; // Reset após a pausa longa
      } else {
        currentMode = PomodoroState.pausa;
      }
    } else {
      // Se terminou uma pausa (curta ou longa), volta para o foco
      currentMode = PomodoroState.foco;
    }

    // Atualiza o tempo restante para o novo modo ativado
    remainingSeconds = _getTimeForMode(currentMode);
    updateUI();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
  }

  void reset(void Function() updateUI) {
    pause();
    remainingSeconds = _getTimeForMode(currentMode);
    updateUI();
  }

  int _getTimeForMode(PomodoroState mode) {
    switch (mode) {
      case PomodoroState.foco:
        return focusTime;
      case PomodoroState.pausa:
        return breakTime;
      case PomodoroState.descanso:
        return longBreakTime;
    }
  }

  void changeMode(PomodoroState newMode, void Function() updateUI) {
    pause();
    currentMode = newMode;
    remainingSeconds = _getTimeForMode(newMode);
    updateUI();
  }

  // Método auxiliar para formatar os segundos em "MM:SS"
  String get formattedTime {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

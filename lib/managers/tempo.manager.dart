import 'dart:async';

import 'package:get_it/get_it.dart';

import 'package:appserap/interfaces/loggable.interface.dart';

typedef DuracaoChangeCallback = void Function(TempoChangeData changeData);

enum EnumProvaTempoEventType { INICIADO, EXTENDIDO, FINALIZADO }

class GerenciadorTempo with Loggable, Disposable {
  late DateTime dataHoraInicioProva;

  late Duration duracaoProva;
  Duration? duracaoTempoExtra;
  late Duration duracaoTempoFinalizando;

  bool tempoAcabando = false;

  EnumProvaTempoEventType estagioTempo = EnumProvaTempoEventType.INICIADO;

  DuracaoChangeCallback? _onChangeDuracaoCallback;

  Timer? timer;
  Timer? timerAdicional;

  configure({
    required DateTime dataHoraInicioProva,
    required Duration duracaoProva,
    required Duration duracaoTempoExtra,
    required Duration duracaoTempoFinalizando,
  }) {
    this.dataHoraInicioProva = dataHoraInicioProva;
    this.duracaoProva = duracaoProva;
    this.duracaoTempoExtra = duracaoTempoExtra;
    this.duracaoTempoFinalizando = duracaoTempoFinalizando;

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: EnumProvaTempoEventType.INICIADO,
          porcentagemTotal: 0,
          tempoRestante: duracaoProva,
          tempoAcabando: tempoAcabando,
        ),
      );
    }

    timer = Timer.periodic(Duration(milliseconds: 100), (_) => process());
  }

  process() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoProva.inMilliseconds) - 1) * -1;

    if (tempoRestante < duracaoTempoFinalizando) {
      tempoAcabando = true;
    } else {
      tempoAcabando = false;
    }

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 0;
      timer?.cancel();

      bool possuiTempoExtra = duracaoTempoExtra != null && duracaoTempoExtra!.inSeconds > 0;

      if (possuiTempoExtra) {
        estagioTempo = EnumProvaTempoEventType.EXTENDIDO;
        iniciarTimerProvaExtendida();
      } else {
        estagioTempo = EnumProvaTempoEventType.FINALIZADO;
      }
    }
    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: estagioTempo,
          porcentagemTotal: porcentagemDecorrida,
          tempoRestante: Duration(
            seconds: tempoRestante.inSeconds,
          ),
          tempoAcabando: tempoAcabando,
        ),
      );
    }
  }

  iniciarTimerProvaExtendida() {
    timerAdicional = Timer.periodic(Duration(milliseconds: 100), (_) => processAdicional());
  }

  processAdicional() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva + duracaoTempoExtra!).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoTempoExtra!.inMilliseconds) - 1) * -1;

    if (tempoRestante < duracaoTempoFinalizando) {
      tempoAcabando = true;
    } else {
      tempoAcabando = false;
    }

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 0;
      timerAdicional?.cancel();

      estagioTempo = EnumProvaTempoEventType.FINALIZADO;
    }

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: estagioTempo,
          porcentagemTotal: porcentagemDecorrida,
          tempoRestante: Duration(seconds: tempoRestante.inSeconds),
          tempoAcabando: tempoAcabando,
        ),
      );
    }
  }

  onChangeDuracao(DuracaoChangeCallback onChangeDuracaoCallback) {
    _onChangeDuracaoCallback = onChangeDuracaoCallback;
  }

  @override
  onDispose() {
    timer?.cancel();
    timerAdicional?.cancel();
  }
}

class TempoChangeData {
  EnumProvaTempoEventType eventType;
  double porcentagemTotal;
  Duration tempoRestante;
  bool tempoAcabando;

  TempoChangeData({
    required this.eventType,
    required this.porcentagemTotal,
    required this.tempoRestante,
    required this.tempoAcabando,
  });
}

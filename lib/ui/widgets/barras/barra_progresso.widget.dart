import 'package:appserap/managers/tempo.manager.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum EnumBarraProgressoVariant { NORMAL, ACABANDO, EXTENDIDO }

class BarraProgresso extends StatelessWidget {
  final double progresso;
  final Duration tempoRestante;
  final EnumProvaTempoEventType? variant;
  final bool alerta;

  const BarraProgresso({
    Key? key,
    this.progresso = 0,
    this.tempoRestante = const Duration(seconds: 0),
    this.variant = EnumProvaTempoEventType.INICIADO,
    this.alerta = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = progresso;

    if (progresso < 0) {
      value = 0;
    }

    if (progresso > 1) {
      value = 1;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.access_time_filled,
              size: 24,
              color: _getColor(),
            ),
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 8.0,
              percent: value,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: _getColor(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Texto(_getText(), fontSize: 14),
                Texto(formatDuration(tempoRestante), fontSize: 14, bold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (alerta) {
      return TemaUtil.vermelhoErro;
    }

    switch (variant) {
      case EnumProvaTempoEventType.EXTENDIDO:
        return TemaUtil.laranja04;

      default:
        return TemaUtil.verde02;
    }
  }

  String _getText() {
    switch (variant) {
      case EnumProvaTempoEventType.EXTENDIDO:
        return 'Revisão acaba em: ';

      default:
        return 'Restam: ';
    }
  }
}

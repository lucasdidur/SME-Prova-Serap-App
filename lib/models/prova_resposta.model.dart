import 'package:json_annotation/json_annotation.dart';

part 'prova_resposta.model.g.dart';

@JsonSerializable()
class ProvaResposta {
  String codigoEOL;
  int questaoId;
  int? alternativaId;
  String? resposta;
  bool sincronizado = false;
  int? tempoRespostaAluno;
  DateTime? dataHoraResposta = DateTime.now();

  ProvaResposta({
    required this.codigoEOL,
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.sincronizado,
    this.dataHoraResposta,
    this.tempoRespostaAluno,
  });

  factory ProvaResposta.fromJson(Map<String, dynamic> json) => _$ProvaRespostaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaRespostaToJson(this);

  @override
  String toString() {
    return 'ProvaResposta(codigoEOL: $codigoEOL, questaoId: $questaoId, alternativaId: $alternativaId, resposta: $resposta, sincronizado: $sincronizado, dataHoraResposta: $dataHoraResposta)';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resposta.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResposta _$ProvaRespostaFromJson(Map<String, dynamic> json) =>
    ProvaResposta(
      codigoEOL: json['codigoEOL'] as String,
      questaoId: json['questaoId'] as int,
      alternativaId: json['alternativaId'] as int?,
      resposta: json['resposta'] as String?,
      sincronizado: json['sincronizado'] as bool,
      dataHoraResposta: json['dataHoraResposta'] == null
          ? null
          : DateTime.parse(json['dataHoraResposta'] as String),
      tempoRespostaAluno: json['tempoRespostaAluno'] as int?,
    );

Map<String, dynamic> _$ProvaRespostaToJson(ProvaResposta instance) =>
    <String, dynamic>{
      'codigoEOL': instance.codigoEOL,
      'questaoId': instance.questaoId,
      'alternativaId': instance.alternativaId,
      'resposta': instance.resposta,
      'sincronizado': instance.sincronizado,
      'tempoRespostaAluno': instance.tempoRespostaAluno,
      'dataHoraResposta': instance.dataHoraResposta?.toIso8601String(),
    };

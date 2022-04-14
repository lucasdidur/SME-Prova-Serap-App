// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_detalhes.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaDetalhesResponseDTO _$ProvaDetalhesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ProvaDetalhesResponseDTO(
      provaId: json['provaId'] as int,
      questoesId:
          (json['questoesId'] as List<dynamic>).map((e) => e as int).toList(),
      arquivosId:
          (json['arquivosId'] as List<dynamic>).map((e) => e as int).toList(),
      videosId:
          (json['videosId'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
      audiosId:
          (json['audiosId'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
      alternativasId: (json['alternativasId'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      tamanhoTotalArquivos: json['tamanhoTotalArquivos'] as int,
      contextoProvaIds: (json['contextoProvaIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ProvaDetalhesResponseDTOToJson(
        ProvaDetalhesResponseDTO instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'questoesId': instance.questoesId,
      'arquivosId': instance.arquivosId,
      'videosId': instance.videosId,
      'audiosId': instance.audiosId,
      'alternativasId': instance.alternativasId,
      'tamanhoTotalArquivos': instance.tamanhoTotalArquivos,
      'contextoProvaIds': instance.contextoProvaIds,
    };

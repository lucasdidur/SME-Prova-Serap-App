// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArquivoResponseDTO _$ArquivoResponseDTOFromJson(Map<String, dynamic> json) =>
    ArquivoResponseDTO(
      id: json['id'] as int,
      caminho: json['caminho'] as String,
      questaoId: json['questaoId'] as int,
    );

Map<String, dynamic> _$ArquivoResponseDTOToJson(ArquivoResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caminho': instance.caminho,
      'questaoId': instance.questaoId,
    };

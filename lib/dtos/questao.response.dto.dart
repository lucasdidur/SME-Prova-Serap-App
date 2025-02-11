import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao.response.dto.g.dart';

@JsonSerializable()
class QuestaoResponseDTO {
  int id;
  String titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;
  int quantidadeAlternativas;

  QuestaoResponseDTO({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
    required this.tipo,
    required this.quantidadeAlternativas,
  });

  static const fromJson = _$QuestaoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoResponseDTOToJson(this);

  @override
  String toString() {
    return 'QuestaoResponseDTO(id: $id, titulo: $titulo, descricao: $descricao, ordem: $ordem, tipo: $tipo)';
  }
}

import 'dart:async';
import 'package:appserap/dtos/orientacao_inicial.response.dto.dart';
import 'package:chopper/chopper.dart';

part 'contexto_prova.service.chopper.dart';

@ChopperApi(baseUrl: "/v1/configuracoes/")
abstract class ContextoProvaService extends ChopperService {
  static ContextoProvaService create([ChopperClient? client]) => _$ContextoProvaService(client);

  @Get(path: 'telas-boas-vindas')
  Future<Response<List<OrientacaoInicialResponseDTO>>> getContextoProva();

}
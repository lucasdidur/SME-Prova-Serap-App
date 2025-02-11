import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:flutter/foundation.dart';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:workmanager/workmanager.dart';

class SincronizarRespostasWorker with Worker, Loggable {
  setup() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await Workmanager().registerPeriodicTask(
          "2",
          "SincronizarRespostasWorker",
          frequency: Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
      } else {
        return Timer.periodic(Duration(minutes: 15), (timer) {
          sincronizar();
        });
      }
    }

    Timer.periodic(Duration(minutes: 1), (timer) {
      sincronizar();
    });
  }

  @override
  onFetch(String taskId) async {
    fine('[Worker] Event received.');
    sincronizar();
  }

  Future<void> sincronizar([List<ProvaResposta>? respostas]) async {
    fine('Sincronizando respostas para o servidor');

    var respostasLocal = respostas ?? carregaRespostasCache();
    finer('${respostasLocal.length} respostas salvas localmente');

    var respostasNaoSincronizadas = respostasLocal.where((element) => element.sincronizado == false);
    fine('${respostasNaoSincronizadas.length} respostas ainda não sincronizadas');

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
    if (respostasNaoSincronizadas.isNotEmpty && resultado == ConnectivityStatus.none) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    var respostasDTO = respostasNaoSincronizadas
        .map((e) => QuestaoRespostaDTO(
              alunoRa: e.codigoEOL,
              questaoId: e.questaoId,
              alternativaId: e.alternativaId,
              resposta: e.resposta,
              dataHoraRespostaTicks: getTicks(e.dataHoraResposta!),
              tempoRespostaAluno: e.tempoRespostaAluno,
            ))
        .toList();

    final _service = ServiceLocator.get<ApiService>().questaoResposta;

    try {
      var response = await _service.postResposta(
        chaveAPI: AppConfigReader.getChaveApi(),
        respostas: respostasDTO,
      );

      if (response.isSuccessful) {
        for (var resposta in respostasNaoSincronizadas) {
          fine("[${resposta.questaoId}] Resposta Sincronizada - ${resposta.alternativaId ?? resposta.resposta}");
          resposta.sincronizado = true;
          await saveCahe(resposta);
        }
      }
    } catch (e) {
      severe(e);
    }

    fine('Sincronização com o servidor servidor concluida');
  }

  salvarCacheMap(Map<int, ProvaResposta> respostas) async {
    List<Future<bool>> futures = [];

    for (var respostaLocal in respostas.entries) {
      futures.add(saveCahe(respostaLocal.value));
    }

    await Future.wait(futures);
  }

  saveCahe(ProvaResposta resposta) async {
    SharedPreferences _pref = GetIt.I.get();

    return await _pref.setString(
      'resposta_${resposta.codigoEOL}_${resposta.questaoId}',
      jsonEncode(resposta.toJson()),
    );
  }

  List<ProvaResposta> carregaRespostasCache() {
    SharedPreferences _pref = GetIt.I.get();

    List<String> keysResposta = _pref.getKeys().toList().where((element) => element.startsWith('resposta_')).toList();

    List<ProvaResposta> respostas = [];

    if (keysResposta.isNotEmpty) {
      for (var keyResposta in keysResposta) {
        var provaResposta = ProvaResposta.fromJson(jsonDecode(_pref.getString(keyResposta)!));

        respostas.add(provaResposta);
      }
    }

    return respostas;
  }
}

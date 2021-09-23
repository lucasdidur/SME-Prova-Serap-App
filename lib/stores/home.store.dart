import 'dart:convert';
import 'dart:io';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store, Loggable {
  @observable
  ObservableList<ProvaStore> provas = ObservableList<ProvaStore>();

  @observable
  bool carregando = false;

  @action
  carregarProvas() async {
    carregando = true;
    List<ProvaStore> provasStore = [];
    try {
      var response = await GetIt.I.get<ApiService>().prova.getProvas();

      if (response.isSuccessful) {
        var provasResponse = response.body!;

        for (var provaResponse in provasResponse) {
          var provaStore = ProvaStore(
            id: provaResponse.id,
            prova: Prova(
              id: provaResponse.id,
              itensQuantidade: provaResponse.itensQuantidade,
              dataInicio: provaResponse.dataInicio,
              dataFim: provaResponse.dataFim,
              descricao: provaResponse.descricao,
              status: provaResponse.status,
              questoes: [],
            ),
          );
          provaStore.downloadStatus = EnumDownloadStatus.NAO_INICIADO;

          provasStore.add(provaStore);
        }
      }
    } on SocketException {
      // Carrega provas do cache
      List<int> ids = listProvasCache();

      for (var id in ids) {
        var provaBanco = carregaProvaCache(id)!;
        provasStore.add(ProvaStore(
          id: id,
          prova: provaBanco,
        ));
      }
    } catch (e, stacktrace) {
      severe(e, stacktrace);
    }

    if (provasStore.isNotEmpty) {
      for (var provaStore in provasStore) {
        provaStore.setupReactions();
        await carregaProva(provaStore.id, provaStore);
      }
    }
    provas = ObservableList.of(provasStore);

    carregando = false;
  }

  List<int> listProvasCache() {
    SharedPreferences _pref = GetIt.I.get();

    var ids = _pref.getKeys().toList().where((element) => element.startsWith('prova_'));

    if (ids.isNotEmpty) {
      return ids.map((e) => e.replaceAll('prova_', '')).map((e) => int.parse(e)).toList();
    }
    return [];
  }

  Future<void> carregaProva(int idProva, ProvaStore provaStore) async {
    var prova = carregaProvaCache(idProva);

    if (prova != null) {
      provaStore.prova = prova;
      provaStore.downloadStatus = prova.downloadStatus;
      provaStore.progressoDownload = prova.downloadProgresso;
      provaStore.status = prova.status;
    } else {
      await salvaProvaCache(provaStore.prova);
    }

    if (provaStore.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
      provaStore.iniciarDownload();
    }
  }

  Prova? carregaProvaCache(int idProva) {
    var _pref = GetIt.I.get<SharedPreferences>();

    String? provaJson = _pref.getString('prova_$idProva');

    if (provaJson != null) {
      return Prova.fromJson(jsonDecode(provaJson));
    }
  }

  salvaProvaCache(Prova prova) async {
    var _pref = GetIt.I.get<SharedPreferences>();
    await _pref.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }

  @action
  dispose() {
    limpar();
  }

  @action
  limpar() {
    provas = <ProvaStore>[].asObservable();
  }
}

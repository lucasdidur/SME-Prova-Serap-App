import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  @observable
  String? token;

  @observable
  DateTime? tokenDataHoraExpiracao;

  @observable
  DateTime? ultimoLogin;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;

  @observable
  String? tipoTurno;

  @observable
  double? tamanhoFonte = 16;

  @observable
  FonteTipoEnum? familiaFonte = FonteTipoEnum.POPPINS;

  @computed
  bool get isLogado => codigoEOL != null;

  @action
  void dispose() {
    if (ano != null && ano!.isNotEmpty) {
      desinscreverTurmaFirebase(ano!);
    }

    nome = null;
    token = null;
    codigoEOL = null;
    ano = null;
    tamanhoFonte = 16;
    familiaFonte = FonteTipoEnum.POPPINS;
  }

  @action
  Future<void> carregarUsuario() async {
    SharedPreferences prefs = GetIt.I.get();
    nome = prefs.getString("serapUsuarioNome");
    token = prefs.getString("serapUsuarioToken");
    codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    ano = prefs.getString("serapUsuarioAno");
    tipoTurno = prefs.getString("serapUsuarioTipoTurno");

    if (prefs.getString("ultimoLogin") != null) {
      ultimoLogin = DateTime.tryParse(prefs.getString("ultimoLogin")!);
    }

    if (prefs.containsKey('familiaFonte')) {
      familiaFonte = FonteTipoEnum.values[prefs.getInt("familiaFonte")!];
    }

    if (prefs.containsKey('tamanhoFonte')) {
      tamanhoFonte = prefs.getDouble("tamanhoFonte")!;
    }

    if (ano != null && ano!.isNotEmpty) {
      await inscreverTurmaFirebase(ano!);
    }
  }

  @action
  atualizarDados({
    required String nome,
    String? codigoEOL,
    String? token,
    required String ano,
    required String tipoTurno,
    DateTime? ultimoLogin,
    required double tamanhoFonte,
    required FonteTipoEnum familiaFonte,
  }) async {
    this.nome = nome;
    this.ano = ano;
    this.tipoTurno = tipoTurno;
    this.ultimoLogin = ultimoLogin;
    this.tamanhoFonte = tamanhoFonte;
    this.familiaFonte = familiaFonte;

    SharedPreferences prefs = GetIt.I.get();
    await prefs.setString('serapUsuarioNome', nome);

    if (token != null && token.isNotEmpty) {
      this.token = token;
      await prefs.setString('serapUsuarioToken', token);
    }

    if (codigoEOL != null && codigoEOL.isNotEmpty) {
      this.codigoEOL = codigoEOL;
      await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    }

    await prefs.setString('serapUsuarioAno', ano);
    await prefs.setString('serapUsuarioTipoTurno', tipoTurno);

    if (this.ultimoLogin != null) {
      await prefs.setString('ultimoLogin', ultimoLogin.toString());
    }

    await prefs.setDouble('tamanhoFonte', tamanhoFonte);
    await prefs.setInt('familiaFonte', familiaFonte.index);

    await inscreverTurmaFirebase(ano);
  }
}

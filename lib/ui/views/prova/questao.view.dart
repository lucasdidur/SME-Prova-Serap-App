import 'dart:typed_data';

import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/questao.store.dart';
import 'package:appserap/ui/views/prova/widgets/questao_aluno.widget.dart';
import 'package:appserap/ui/views/prova/widgets/tempo_execucao.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/audio_player/audio_player.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/video_player/video_player.widget.dart';
import 'package:appserap/utils/file.util.dart';
import 'package:appserap/utils/idb_file.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class QuestaoView extends BaseStatefulWidget {
  final int idProva;
  final int ordem;

  QuestaoView({Key? key, required this.idProva, required this.ordem}) : super(key: key);

  @override
  _QuestaoViewState createState() => _QuestaoViewState();
}

class _QuestaoViewState extends BaseStateWidget<QuestaoView, QuestaoStore> with Loggable {
  late ProvaStore provaStore;
  late Questao questao;
  late Map<int, Uint8List> arquivosVideo = {};

  final controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    store.isLoading = true;

    configure().then((_) {
      store.isLoading = false;
    });
  }

  configure() async {
    var provas = ServiceLocator.get<HomeStore>().provas;

    if (provas.isEmpty) {
      ServiceLocator.get<AppRouter>().router.go("/");
      return;
    }

    provaStore = provas.filter((prova) => prova.key == widget.idProva).first.value;
    questao = provaStore.prova.questoes.where((element) => element.ordem == widget.ordem).first;

    if (kIsWeb) {
      await loadVideos(questao);
    }
  }

  loadVideos(Questao questao) async {
    for (var arquivoVideo in questao.arquivosVideos) {
      IdbFile idbFile = IdbFile(arquivoVideo.path);

      if (await idbFile.exists()) {
        Uint8List readContents = Uint8List.fromList(await idbFile.readAsBytes());
        info('abrindo video ${formatBytes(readContents.lengthInBytes, 2)}');
        arquivosVideo[arquivoVideo.id] = readContents;
      }
    }
  }

  Future<Uint8List?> loadAudio(Questao questao) async {
    if (questao.arquivosAudio.isNotEmpty) {
      IdbFile idbFile = IdbFile(questao.arquivosAudio.first.path);

      if (await idbFile.exists()) {
        Uint8List readContents = Uint8List.fromList(await idbFile.readAsBytes());
        info('abrindo audio ${formatBytes(readContents.lengthInBytes, 2)}');
        return readContents;
      }
    }
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: provaStore.prova.descricao,
      leading: _buildLeading(),
    );
  }

  Widget? _buildLeading() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        bool voltar = (await mostrarDialogVoltarProva(context)) ?? false;

        if (voltar) {
          provaStore.setRespondendoProva(false);
          context.go("/");
        }
      },
    );
  }

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (context) {
      if (store.isLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Carregando..."),
          ],
        );
      }

      return Scaffold(
        body: Column(
          children: [
            TempoExecucaoWidget(provaStore: provaStore),
            _buildAudioPlayer(),
            Expanded(
              child: _builLayout(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: questao.arquivosVideos.isEmpty ? getPadding() : EdgeInsets.zero,
                    child: Column(
                      children: [
                        SizedBox(
                          width: questao.arquivosVideos.isNotEmpty ? MediaQuery.of(context).size.width * 0.5 : null,
                          child: Observer(builder: (_) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Questão ${questao.ordem + 1} ',
                                        style: TemaUtil.temaTextoNumeroQuestoes.copyWith(
                                          fontSize: temaStore.tTexto20,
                                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                        ),
                                      ),
                                      Text(
                                        'de ${provaStore.prova.questoes.length}',
                                        style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                                          fontSize: temaStore.tTexto20,
                                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  QuestaoAlunoWidget(
                                    provaStore: provaStore,
                                    questao: questao,
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            );
                          }),
                        ),
                        Observer(builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 20,
                            ),
                            child: _buildBotoes(questao),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _builLayout({required Widget body}) {
    if (exibirVideo()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: body,
          ),
          _buildVideoPlayer(),
        ],
      );
    } else {
      return body;
    }
  }

  Widget _buildAudioPlayer() {
    if (!exibirAudio()) {
      return SizedBox.shrink();
    }

    if (kIsWeb) {
      return FutureBuilder<Uint8List?>(
        future: loadAudio(questao),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AudioPlayerWidget(
              audioBytes: snapshot.data,
            );
          }

          return SizedBox.shrink();
        },
      );
    } else {
      if (questao.arquivosAudio.isNotEmpty) {
        return AudioPlayerWidget(
          audioPath: questao.arquivosAudio.first.path,
        );
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.only(right: 16),
      child: FutureBuilder<Widget>(
        future: showVideoPlayer(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done ? snapshot.data! : Container();
        },
      ),
    );
  }

  Widget _buildBotoes(Questao questao) {
    Widget botoesRespondendoProva = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildBotaoVoltar(questao),
        _buildBotaoProximo(questao),
      ],
    );

    if (kIsMobile || kIsTablet && questao.arquivosVideos.isNotEmpty) {
      botoesRespondendoProva = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBotaoVoltar(questao),
          _buildBotaoProximo(questao),
        ],
      );
    }

    return botoesRespondendoProva;
  }

  Widget _buildBotaoVoltar(Questao questao) {
    if (widget.ordem == 0) {
      return SizedBox.shrink();
    }

    return BotaoSecundarioWidget(
      textoBotao: 'Questão anterior',
      onPressed: () async {
        provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
        await provaStore.respostas.definirTempoResposta(
          questao.id,
          tempoQuestao: provaStore.segundos,
        );
        await provaStore.respostas.sincronizarResposta();
        // Navega para a proxima questão
        context.push("/prova/${widget.idProva}/questao/${widget.ordem - 1}");
      },
    );
  }

  Widget _buildBotaoProximo(Questao questao) {
    if (widget.ordem < provaStore.prova.questoes.length - 1) {
      return BotaoDefaultWidget(
        textoBotao: 'Próxima questão',
        desabilitado: store.botaoOcupado,
        onPressed: () async {
          try {
            store.botaoOcupado = true;

            provaStore.tempoCorrendo = EnumTempoStatus.PARADO;

            if (questao.tipo == EnumTipoQuestao.RESPOSTA_CONTRUIDA) {
              await provaStore.respostas.definirResposta(
                questao.id,
                textoResposta: await controller.getText(),
                tempoQuestao: provaStore.segundos,
              );
            }
            if (questao.tipo == EnumTipoQuestao.MULTIPLA_ESCOLHA) {
              await provaStore.respostas.definirTempoResposta(
                questao.id,
                tempoQuestao: provaStore.segundos,
              );
            }
            await provaStore.respostas.sincronizarResposta();
            provaStore.segundos = 0;

            context.push("/prova/${widget.idProva}/questao/${widget.ordem + 1}");
          } catch (e) {
            fine(e);
          } finally {
            store.botaoOcupado = false;
          }
        },
      );
    }

    return BotaoDefaultWidget(
      textoBotao: 'Finalizar prova',
      onPressed: () async {
        try {
          provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
          await provaStore.respostas.definirTempoResposta(
            questao.id,
            tempoQuestao: provaStore.segundos,
          );
          provaStore.segundos = 0;

          await _iniciarRevisaoProva();
        } catch (e) {
          fine(e);
        }
      },
    );
  }

  Future<void> _iniciarRevisaoProva() async {
    await provaStore.respostas.sincronizarResposta(force: true);

    context.go("/prova/${widget.idProva}/resumo");
  }

  Future<Widget> showVideoPlayer() async {
    if (kIsWeb) {
      var file = arquivosVideo.entries.first.value;
      return VideoPlayerWidget(videoUrl: buildUrl(file));
    } else {
      String path = (await buildPath(questao.arquivosVideos.first.path))!;
      return VideoPlayerWidget(videoPath: path);
    }
  }

  bool exibirAudio() {
    if (questao.arquivosAudio.isEmpty) {
      return false;
    }

    for (var deficiencia in principalStore.usuario.deficiencias) {
      if (grupoCegos.contains(deficiencia)) {
        return true;
      }
    }
    return false;
  }

  bool exibirVideo() {
    if (questao.arquivosVideos.isEmpty) {
      return false;
    }

    for (var deficiencia in principalStore.usuario.deficiencias) {
      if (grupoSurdos.contains(deficiencia)) {
        return true;
      }
    }

    return false;
  }
}

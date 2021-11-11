import 'dart:convert';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/prova/contexto_prova.view.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_stateless.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialog_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';

class ProvaAtualTabView extends BaseStatefulWidget {
  @override
  State<ProvaAtualTabView> createState() => _ProvaAtualTabViewState();
}

class _ProvaAtualTabViewState extends BaseStatelessWidget<ProvaAtualTabView, HomeStore> {
  final _principalStore = GetIt.I.get<PrincipalStore>();

  final temaStore = GetIt.I<TemaStore>();

  FocusNode _codigoProvaFocus = FocusNode();

  List<ApresentacaoModelWidget> listaContextoProva = [
    ApresentacaoModelWidget(
      ehHTML: true,
      descricao: '',
      corpoPersonalizado: Html(
        data:
            '<p><img src="https://via.placeholder.com/150/0000FF/808080%20" alt="" width="150" height="150" /></p><h2>Teste</h2><p>Teste de texto</p>',
        style: {
          '*': Style.fromTextStyle(
            TextStyle(
              fontFamily:
                  ServiceLocator.get<TemaStore>().fonteDoTexto.nomeFonte,
              fontSize: ServiceLocator.get<TemaStore>().size(16),
            ),
          )
        },
      ),
      titulo: '',
      imagem: CircularProgressIndicator(),
    ),
    ApresentacaoModelWidget(
      ehHTML: true,
      descricao: '',
      corpoPersonalizado: Html(
        data:
            '<p><img src="https://via.placeholder.com/150/0000FF/808080%20" alt="" width="150" height="150" /></p><h2>Teste</h2><p>Teste de texto</p>',
        style: {
          '*': Style.fromTextStyle(
            TextStyle(
              fontFamily:
                  ServiceLocator.get<TemaStore>().fonteDoTexto.nomeFonte,
              fontSize: ServiceLocator.get<TemaStore>().size(16),
            ),
          )
        },
      ),
      titulo: '',
      imagem: CircularProgressIndicator(),
    ),
    ApresentacaoModelWidget(
      ehHTML: true,
      descricao: '',
      corpoPersonalizado: Html(
        data:
            '<p><img src="https://via.placeholder.com/150/0000FF/808080%20" alt="" width="150" height="150" /></p><h2>Teste</h2><p>Teste de texto</p>',
        style: {
          '*': Style.fromTextStyle(
            TextStyle(
              fontFamily:
                  ServiceLocator.get<TemaStore>().fonteDoTexto.nomeFonte,
              fontSize: ServiceLocator.get<TemaStore>().size(16),
            ),
          )
        },
      ),
      titulo: '',
      imagem: CircularProgressIndicator(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    store.carregarProvas();
  }

  @override
  Widget builder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
      child: Observer(
        builder: (_) {
          ObservableMap<int, ProvaStore> provas = store.provas;

          if (store.carregando) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provas.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: SvgPicture.asset(
                        'assets/images/sem_prova.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Texto(
                        "Você não tem novas\nprovas para fazer.",
                        fontSize: 18,
                        center: true,
                        fontWeight: FontWeight.w600,
                        color: TemaUtil.pretoSemFoco3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await store.carregarProvas();
            },
            child: ListView.builder(
              itemCount: provas.length,
              itemBuilder: (_, index) {
                var keys = provas.keys.toList();
                var prova = provas[keys[index]]!;
                return _buildProva(prova);
              },
            ),
          );
        },
      ),
    );
  }

  _buildProva(ProvaStore provaStore) {
    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    bool telaMobileMenor = tela.size.width <= 400 ? true : false;

    var espacamentoInterno = 24.0;

    var espacamentoInternoBlocoProva = EdgeInsets.all(espacamentoInterno);

    if (kIsMobile) {
      espacamentoInterno = 8.0;

      espacamentoInternoBlocoProva = EdgeInsets.fromLTRB(8, 8, 0, 12);
    }

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: TemaUtil.branco,
        border: Border.all(color: TemaUtil.cinza),
      ),
      child: Padding(
        padding: espacamentoInternoBlocoProva,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) {
                if (kIsMobile) {
                  return SizedBox();
                }
                return SvgPicture.asset(provaStore.icone);
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: espacamentoInterno),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titulo
                    Observer(
                      builder: (_) {
                        var tamanhoFonte = temaStore.tTexto16;
                        if (kIsMobile) {
                          tamanhoFonte = temaStore.tTexto14;
                        }

                        return Texto(
                          provaStore.prova.descricao,
                          fontSize: tamanhoFonte,
                          bold: true,
                          maxLines: 3,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    // Quantidade de itens
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: TemaUtil.laranja02.withOpacity(0.1),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.format_list_numbered,
                            color: TemaUtil.laranja02,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        //
                        Observer(
                          builder: (context) {
                            var tamanhoFonte = temaStore.tTexto16;
                            if (kIsMobile) {
                              tamanhoFonte = temaStore.tTexto14;
                            }
                            if (telaMobileMenor) {
                              tamanhoFonte = temaStore.tTexto12;
                            }

                            return RichText(
                              text: TextSpan(
                                text: "Quantidade de itens: ",
                                style: TemaUtil.temaTextoPadrao.copyWith(
                                  fontSize: tamanhoFonte,
                                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                ),
                                children: [
                                  TextSpan(
                                    style: TemaUtil.temaTextoPadrao.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: tamanhoFonte,
                                      fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                    ),
                                    text: tamanhoFonte >= 22 || telaMobileMenor
                                        ? '\n${provaStore.prova.itensQuantidade.toString()}'
                                        : provaStore.prova.itensQuantidade.toString(),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Data aplicacao
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: TemaUtil.verde02.withOpacity(0.1),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.insert_invitation,
                            color: TemaUtil.verde02,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataAplicacao(),
                            SizedBox(
                              width: kIsMobile ? 250 : 350,
                              child: _formataDataAplicacao(provaStore.prova),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Botao
                    Observer(builder: (_) {
                      return _buildBotao(provaStore);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formataDataAplicacao(Prova prova) {
    var tamanhoFonte = temaStore.tTexto18;

    if (prova.dataFim == null || prova.dataInicio == prova.dataFim) {
      return Observer(
        builder: (_) {
          return AutoSizeText(
            formatEddMMyyyy(prova.dataInicio),
            maxLines: 4,
            style: TemaUtil.temaTextoPadraoNegrito.copyWith(
              fontSize: tamanhoFonte,
              fontFamily: temaStore.fonteDoTexto.nomeFonte,
            ),
          );
        },
      );
    }

    if (prova.dataInicio != prova.dataFim) {
      return Observer(
        builder: (_) {
          int tamanhoFonteParaQuebrarTexto = 18;

          if (kIsMobile) {
            tamanhoFonte = temaStore.tTexto16;
            tamanhoFonteParaQuebrarTexto = 14;

            if (temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC) {
              tamanhoFonte = temaStore.tTexto14;
              tamanhoFonteParaQuebrarTexto = 12;
            }
          }

          return Container(
            child: tamanhoFonte >= tamanhoFonteParaQuebrarTexto
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        formatEddMMyyyy(prova.dataInicio),
                        maxLines: 2,
                        style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                          fontSize: tamanhoFonte,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: AutoSizeText(
                          " à ",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TemaUtil.temaTextoPadrao.copyWith(
                            fontSize: tamanhoFonte,
                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        formatEddMMyyyy(prova.dataFim!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                          fontSize: tamanhoFonte,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      AutoSizeText(
                        formatEddMMyyyy(prova.dataInicio),
                        maxLines: 1,
                        style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                          fontSize: tamanhoFonte,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                      AutoSizeText(
                        " à ",
                        maxLines: 1,
                        style: TemaUtil.temaTextoPadrao.copyWith(
                          fontSize: tamanhoFonte,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                      AutoSizeText(
                        formatEddMMyyyy(prova.dataFim!),
                        maxLines: 1,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        style: TemaUtil.temaTextoPadraoNegrito.copyWith(
                          fontSize: tamanhoFonte,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
    }

    return SizedBox();
  }

  _buildBotao(ProvaStore provaStore) {
    // Download não iniciado e sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.NAO_INICIADO && !_principalStore.temConexao) {
      return _buildSemConexao(provaStore);
    }

    // Download prova pausado sem conexão
    if (provaStore.downloadStatus == EnumDownloadStatus.PAUSADO && !_principalStore.temConexao) {
      return _buildPausado(provaStore);
    }

    // Baixar prova
    if (provaStore.downloadStatus == EnumDownloadStatus.NAO_INICIADO && _principalStore.temConexao) {
      return _buildBaixarProva(provaStore);
    }

    // Baixando prova
    if (provaStore.downloadStatus == EnumDownloadStatus.BAIXANDO && _principalStore.temConexao) {
      return _buildDownloadProgresso(provaStore);
    }

    // Prova baixada -- iniciar
    if (provaStore.downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      if (provaStore.status == EnumProvaStatus.PENDENTE) {
        // Prova finalizada - aguardando sincronização
        return _buildProvaPendente(provaStore);
      } else {
        // Prova não finalizada
        return _buildIniciarProva(provaStore);
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildSemConexao(ProvaStore provaStore) {
    return SizedBox(
      width: 350,
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 4.0,
              percent: provaStore.progressoDownload,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Download não iniciado",
                  color: TemaUtil.vermelhoErro,
                  bold: true,
                  texStyle: TemaUtil.temaTextoErroNegrito.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Texto(
                  " - Sem conexão com a internet",
                  color: TemaUtil.vermelhoErro,
                  texStyle: TemaUtil.temaTextoErro.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausado(ProvaStore provaStore) {
    return SizedBox(
      width: 350,
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: LinearPercentIndicator(
              lineHeight: 4.0,
              percent: provaStore.progressoDownload,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: TemaUtil.vermelhoErro,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Texto(
                  "Pausado em ${(provaStore.progressoDownload * 100).toStringAsFixed(1)}%",
                  color: TemaUtil.vermelhoErro,
                  bold: true,
                  texStyle: TemaUtil.temaTextoErroNegrito.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Texto(
                  " - Sem conexão com a internet",
                  color: TemaUtil.vermelhoErro,
                  texStyle: TemaUtil.temaTextoErro.copyWith(
                    fontSize: temaStore.tTexto12,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaixarProva(ProvaStore provaStore) {
    var tamanhoFonte = temaStore.tTexto16;
    if (kIsMobile) {
      tamanhoFonte = temaStore.tTexto14;
    }

    return BotaoDefaultWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.download, color: Colors.white, size: 18),
          Observer(
            builder: (_) {
              return Texto(
                " BAIXAR PROVA",
                color: Colors.white,
                fontWeight: FontWeight.w500,
                texStyle: TemaUtil.temaTextoBotao.copyWith(
                  fontSize: tamanhoFonte,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                ),
              );
            },
          ),
        ],
      ),
      largura: 256,
      onPressed: () async {
        await provaStore.iniciarDownload();
      },
    );
  }

  Widget _buildProvaPendente(ProvaStore provaStore) {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            lineHeight: 7.0,
            percent: 1,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: TemaUtil.laranja02,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Row(
              children: [
                Observer(
                  builder: (_) {
                    return Texto(
                      "Aguardando envio",
                      color: TemaUtil.laranja01,
                      bold: true,
                      texStyle: TemaUtil.temaTextoAguardandoEnvio.copyWith(
                        fontSize: temaStore.tTexto12,
                        fontFamily: temaStore.fonteDoTexto.nomeFonte,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIniciarProva(ProvaStore provaStore) {
    String texto = '';

    switch (provaStore.prova.status) {
      case EnumProvaStatus.INICIADA:
        texto = "CONTINUAR PROVA";
        break;
      default:
        texto = "INICIAR PROVA";
    }

    var tamanhoFonte = 18.0;
    if (kIsMobile) {
      tamanhoFonte = 14.0;
      if (temaStore.incrementador >= 22) {
        tamanhoFonte = 12.0;
      }
    }

    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    bool telaMobileMenor = tela.size.width <= 400 ? true : false;

    return BotaoDefaultWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Texto(
            '$texto ',
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: tamanhoFonte,
          ),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
      largura: kIsMobile
          ? telaMobileMenor
              ? 280
              : 320
          : tamanhoFonte >= 18
              ? 350
              : 312,
      onPressed: () async {
        if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA && provaStore.prova.senha != null) {
          //
          showDialog(
            context: context,
            barrierColor: Colors.black87,
            builder: (context) {
              return DialogDefaultWidget(
                cabecalho: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Observer(builder: (_) {
                    return Texto(
                      "Insira a senha informada para iniciar a prova",
                      center: true,
                      fontSize: tamanhoFonte,
                    );
                  }),
                ),
                corpo: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: TextField(
                      focusNode: _codigoProvaFocus,
                      onChanged: (value) => provaStore.codigoIniciarProva = value,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Digite o código para liberar a prova',
                        labelStyle: TextStyle(
                          color: _codigoProvaFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                        ),
                      ),
                    ),
                  ),
                ),
                botoes: [
                  BotaoDefaultWidget(
                    onPressed: () {
                      String senhaCriptografada = md5.convert(utf8.encode(provaStore.codigoIniciarProva)).toString();

                      if (provaStore.prova.senha == senhaCriptografada) {
                        Navigator.pop(context);

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProvaView(
                        //       provaStore: provaStore,
                        //     ),
                        //   ),
                        // );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContextoProva(
                              listaDePaginas: listaContextoProva,
                              provaStore: provaStore,
                            ),
                          ),
                        );
                      } else {
                        mostrarDialogSenhaErrada(context);
                      }
                    },
                    textoBotao: "ENVIAR CODIGO",
                  ),
                ],
              );
            },
          );
        }

        if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA && provaStore.prova.senha == null) {
          //provaStore.iniciarProva();

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProvaView(
          //       provaStore: provaStore,
          //     ),
          //   ),
          // );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ContextoProva(
                listaDePaginas: listaContextoProva,
                provaStore: provaStore,
              ),
            ),
          );
        }

        if (provaStore.prova.status == EnumProvaStatus.INICIADA){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProvaView(
                provaStore: provaStore,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDownloadProgresso(ProvaStore prova) {
    var tempoRestante = prova.tempoPrevisto > 0 ? " - Aproximadamente ${prova.tempoPrevisto.round()} segundos restantes": "";

    final tela = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    bool telaMobileMenor = tela.size.width <= 400 ? true : false;

    var espacamento = telaMobileMenor ? 280.0 : 350.0;

    return SizedBox(
      width: espacamento,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            //animation: true,
            //animationDuration: 1000,
            lineHeight: 4.0,
            percent: prova.progressoDownload,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: TemaUtil.verde01,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Text(
              "Download em progresso ${(prova.progressoDownload * 100).toStringAsFixed(2)}% $tempoRestante",
              style: TextStyle(
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
                fontSize: temaStore.tTexto14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDataAplicacao() {
    var tamanhoFonte = 16.0;
    if (kIsMobile) {
      tamanhoFonte = 14.0;
    }
    return Texto(
      "Data de aplicação:",
      fontSize: tamanhoFonte,
    );
  }
  //
}

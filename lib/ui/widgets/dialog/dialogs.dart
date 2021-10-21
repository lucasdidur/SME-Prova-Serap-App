import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'dialog_default.widget.dart';

Future<bool>? mostrarDialogSemInternet(BuildContext context) {
  String mensagem = "Sua prova será enviada quando houver conexão com a internet.";
  String icone = AssetsUtil.semConexao;
  String mensagemBotao = "ENTENDI";

  final temaStore = GetIt.I.get<TemaStore>();

  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Observer(
            builder: (_) {
              return Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TemaUtil.temaTextoMensagemDialog.copyWith(
                  fontSize: temaStore.tTexto20,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () async {
              Navigator.of(context).pop();
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogProvaFinalizadaAutomaticamente(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem =
      "Sua prova foi finalizada, pois o tempo acabou. As questões com resposta foram enviadas com sucesso.";
  String icone = AssetsUtil.check;
  String mensagemBotao = "ENTENDI";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

mostrarDialogProvaEnviada(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem = "Sua prova foi enviada com sucesso!";
  String icone = AssetsUtil.check;
  String mensagemBotao = "OK";

  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Observer(
            builder: (_) {
              return Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TemaUtil.temaTextoMensagemDialog.copyWith(
                  fontSize: temaStore.tTexto20,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () {
              Navigator.pop(context);
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

mostrarDialogProvaJaEnviada(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem = "Esta prova já foi finalizada";
  String icone = AssetsUtil.erro;
  String mensagemBotao = "OK";

  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Observer(
            builder: (_) {
              return Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TemaUtil.temaTextoMensagemDialog.copyWith(
                  fontSize: temaStore.tTexto20,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () {
              Navigator.pop(context);
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogAindaPossuiTempo(BuildContext context, Duration tempo) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagemCorpo =
      "Se finalizar a prova agora, não poderá mais fazer alterações mesmo que o tempo não tenha se esgotado";

  return showDialog<bool>(
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
          child: Observer(
            builder: (_) {
              return RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: "Você ainda tem ",
                  style: TemaUtil.temaTextoTempoDialog.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto,
                  ),
                  children: [
                    TextSpan(
                      text: formatDuration(tempo),
                      style: TemaUtil.temaTextoDuracaoDialog.copyWith(
                        fontSize: temaStore.tTexto16,
                        fontFamily: temaStore.fonteDoTexto,
                      ),
                      children: [
                        TextSpan(
                          text: " para fazer a prova, tem certeza que quer finalizar agora?",
                          style: TextStyle(
                            fontSize: temaStore.tTexto16,
                            fontFamily: temaStore.fonteDoTexto,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(mensagemCorpo, textAlign: TextAlign.left, style: TemaUtil.temaTextoMensagemCorpo),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CANCELAR",
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          BotaoDefaultWidget(
            textoBotao: "FINALIZAR PROVA",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}

mostrarDialogSenhaErrada(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagemCorpo = "O código está incorreto. Solicite o código para o professor.";

  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return Observer(builder: (_) {
        return DialogDefaultWidget(
          cabecalho: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: SvgPicture.asset(AssetsUtil.erro),
          ),
          corpo: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              mensagemCorpo,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemCorpo.copyWith(
                fontSize: temaStore.tTexto14,
                fontFamily: temaStore.fonteDoTexto,
              ),
            ),
          ),
          botoes: [
            BotaoDefaultWidget(
              onPressed: () {
                Navigator.pop(context);
              },
              textoBotao: "ENTENDI",
            )
          ],
        );
      });
    },
  );
}

mostrarDialogMudancaTema(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(microseconds: 1),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.topRight,
        child: Observer(
          builder: (_) {
            return Container(
              height: 300,
              width: 300,
              margin: EdgeInsets.only(right: 60),
              padding: EdgeInsets.all(16),
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Tipo de letra",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: Colors.black87,
                          fontFamily: temaStore.fonteDoTexto,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  temaStore.mudarParaFonteNormal();
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  // fixedSize: MaterialStateProperty.all<Size>(
                                  //   Size(85, 70),
                                  // ),
                                ),
                                child: Text(
                                  "Aa",
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Padrão",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        SizedBox(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  temaStore.mudarParaFonteParaDislexia();
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(0),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                ),
                                child: Text(
                                  "Aa",
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.black,
                                    fontFamily: 'OpenDyslexic',
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Para dislexia",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontFamily: "OpenDyslexic",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.black87),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Tamanho da letra",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: temaStore.fonteDoTexto,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "A",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: temaStore.fonteDoTexto,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 8,
                              ),
                              child: Slider(
                                value: temaStore.incrementador,
                                min: 16,
                                max: 24,
                                divisions: 4,
                                label: temaStore.incrementador.round().toString(),
                                activeColor: TemaUtil.azul2,
                                inactiveColor: Colors.grey[350],
                                onChanged: (double valor) {
                                  if (valor >= 16 && valor <= 24) {
                                    temaStore.fachadaAlterarTamanhoDoTexto(valor);
                                  }
                                },
                              ),
                            ),
                          ),
                          Text(
                            "A",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: temaStore.fonteDoTexto,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 0), end: Offset(0, 0.08)).animate(anim),
        child: child,
      );
    },
  );
}

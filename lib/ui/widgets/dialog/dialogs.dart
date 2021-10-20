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
import 'package:google_fonts/google_fonts.dart';

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
                  ),
                  children: [
                    TextSpan(
                      text: formatDuration(tempo),
                      style: TemaUtil.temaTextoDuracaoDialog.copyWith(
                        fontSize: temaStore.tTexto16,
                      ),
                      children: [
                        TextSpan(
                          text: " para fazer a prova, tem certeza que quer finalizar agora?",
                          style: TextStyle(
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
  String mensagemCorpo = "O código está incorreto. Solicite o código para o professor.";

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
          child: SvgPicture.asset(AssetsUtil.erro),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            mensagemCorpo,
            textAlign: TextAlign.center,
            style: TemaUtil.temaTextoMensagemCorpo,
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
    },
  );
}

mostrarDialogMudancaTema(BuildContext context) {
  double _currentSliderValue = 16;
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 500,
            width: 300,
            margin: EdgeInsets.only(top: 65, right: 60),
            padding: EdgeInsets.all(16),
            child: Column(
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
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {},
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
                            onPressed: () {},
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            ),
                            child: Text(
                              "Aa",
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.black,
                                fontFamily: 'Dyslexic',
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
                        ),
                      ),
                      Slider(
                        value: _currentSliderValue,
                        min: 8,
                        max: 24,
                        divisions: 2,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {},
                      ),
                      Text(
                        "A",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
/*showDialog(
    context: context,
    builder: (_) {
      return DialogDefaultWidget(
        maxWidth: 400,
        cabecalho: Container(),
        corpo: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                "Tipo de letra",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
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
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Padrão",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        child: Text(
                          "Oa",
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.black,
                            fontFamily: 'Dyslexic',
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
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentSliderValue,
                      min: 8,
                      max: 24,
                      divisions: 2,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {},
                    ),
                  ),
                  Text(
                    "A",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        botoes: [Container()],
      );
    },
  ); */
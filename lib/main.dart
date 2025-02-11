// ignore_for_file: avoid_print
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/dispacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'utils/firebase.util.dart';

var logger = Logger('Main');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configure();

  await Worker().setup();

  await setupFirebase();

  runApp(MyApp());
}

configure() async {
  setupDateFormating();
  setupLogging();
  registerFonts();

  await setupAppConfig();

  await DependenciasIoC().setup();

  TelaAdaptativaUtil().setup();
}

Future setupAppConfig() async {
  try {
    await AppConfigReader.initialize();
  } catch (error) {
    print("Erro ao ler arquivo de configurações.");
    print("Verifique se seu projeto possui o arquivo config/app_config.json");
    print('$error');
  }
}

void setupLogging() {
  if (kDebugMode) {
    Logger.root.level = Level.FINE;
  } else {
    Logger.root.level = Level.WARNING;
  }

  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: (${rec.loggerName}) ${rec.message}');
  });
}

void registerFonts() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });
}

setupDateFormating() {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        960,
        600,
      ),
      builder: (context) {
        final GoRouter goRouter = ServiceLocator.get<AppRouter>().router;

        return MaterialApp.router(
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          debugShowCheckedModeBanner: kDebugMode,
          theme: ThemeData.light().copyWith(
            appBarTheme: AppBarTheme(backgroundColor: TemaUtil.appBar),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
              ),
            ),
          ),
          locale: Locale('pt', 'BR'),
          scaffoldMessengerKey: NotificacaoUtil.messengerKey,
          onGenerateTitle: (context) => "SERAp Estudantes",
        );
      },
    );
  }
}

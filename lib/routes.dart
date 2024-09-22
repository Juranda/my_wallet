import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/account_settings/account_settings_view.dart';
import 'package:my_wallet/app/home/account_settings/mudar_senha.dart';
import 'package:my_wallet/app/home/account_settings/app_settings_view.dart';
import 'package:my_wallet/app/cadastro/aluno_cadastro_view.dart';
import 'package:my_wallet/app/cadastro/cadastro_moderador.dart';
import 'package:my_wallet/app/cadastro/deletar_cadastro_view.dart';
import 'package:my_wallet/app/cadastro/professor_cadastro_view.dart';
import 'package:my_wallet/app/cadastro/turma_cadastro_view.dart';
import 'package:my_wallet/app/home/homepage_view.dart';
import 'package:my_wallet/app/home/realidade_aumentada/ar_view.dart';
import 'package:my_wallet/app/home/trilhas/trail_view.dart';
import 'package:my_wallet/app/login/login_view.dart';

class Routes {
  static const String LOGIN = '/login';
  static const String HOME = '/home';
  static const String AR = '/ar';
  static const String APP_SETTINGS = '/appSettings';
  static const String ACCOUNT_SETTINGS = '/accountSettings';
  static const String ACCOUNT_SETTINGS_CHANGE_PASSWORD =
      '/accountSettingsChangePassword';
  static const String SIGNUP_DELETAR = '/signup/deletar';
  static const String ADM = '/adm';
  static const String ADM_CADASTRO_ALUNO = '/adm/cadastro-aluno';
  static const String ADM_CADASTRO_PROFESSOR = '/adm/cadastro-professor';
  static const String ADM_CADASTRO_TURMA = '/adm/cadastro-turma';
  static const String TRAILS_TRAIL_DETALHE = '/trails/trail';

  static final Map<String, WidgetBuilder> routes = {
    AR: (context) => ArView(),
    LOGIN: (context) => LoginView(),
    HOME: (context) => HomePageView(),
    APP_SETTINGS: (context) => AppSettingsView(),
    ACCOUNT_SETTINGS: (context) => AccountSettingsView(),
    ACCOUNT_SETTINGS_CHANGE_PASSWORD: (context) => AccountChangePassword(),
    SIGNUP_DELETAR: (context) => DeletarCadastroView(),
    ADM: (context) => CadastroModerador(),
    ADM_CADASTRO_ALUNO: (context) => AlunoCadastroView(),
    ADM_CADASTRO_PROFESSOR: (context) => ProfessorCadastroView(),
    ADM_CADASTRO_TURMA: (context) => TurmaCadastroView(),
    TRAILS_TRAIL_DETALHE: (context) => TrailView()
  };
}

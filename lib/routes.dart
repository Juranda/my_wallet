import 'package:flutter/material.dart';
import 'package:my_wallet/pages/account_settings/account_settings_view.dart';
import 'package:my_wallet/pages/account_settings/mudar_senha.dart';
import 'package:my_wallet/pages/app_settings_view.dart';
import 'package:my_wallet/pages/cadastro/aluno_cadastro_view.dart';
import 'package:my_wallet/pages/cadastro/cadastro_moderador.dart';
import 'package:my_wallet/pages/cadastro/deletar_cadastro_view.dart';
import 'package:my_wallet/pages/cadastro/professor_cadastro_view.dart';
import 'package:my_wallet/pages/cadastro/turma_cadastro_view.dart';
import 'package:my_wallet/pages/homepage_view.dart';
import 'package:my_wallet/pages/login/login_view.dart';

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

  static final Map<String, WidgetBuilder> routes = {
    LOGIN: (context) => LoginView(),
    HOME: (context) => HomePageView(),
    APP_SETTINGS: (context) => AppSettingsView(),
    ACCOUNT_SETTINGS: (context) => AccountSettingsView(),
    ACCOUNT_SETTINGS_CHANGE_PASSWORD: (context) => AccountChangePassword(),
    SIGNUP_DELETAR: (context) => DeletarCadastroView(),
    ADM: (context) => CadastroModerador(),
    ADM_CADASTRO_ALUNO: (context) => AlunoCadastroView(),
    ADM_CADASTRO_PROFESSOR: (context) => ProfessorCadastroView(),
    ADM_CADASTRO_TURMA: (context) => TurmaCadastroView()
  };
}

import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/models/users/usuario.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:my_wallet/services/user_service.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    MyWallet.instance.initialize();
  });
  test('User service cadastra usuario corretamente', () async {
    UserService userService = MyWallet.userService;

    Usuario usuario = await userService.cadastrarUsuario(
      idInstituicaoEnsino: 0,
      nome: 'Dicaprio',
      email: 'pegueme@gmail.com',
      senha: 'senhasecretafbi',
      tipo: Role.Professor,
    );

    assert(usuario.nome == 'Dicaprio');
  });
}

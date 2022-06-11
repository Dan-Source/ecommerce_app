
String getErrorString(String code) {
  const String userNotFound = "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.";
  switch (code) {
    case "ERROR_WRONG_SHORT_PASSWORD":
      return 'Sua senha é muito fraca.';
    case 'ERROR_INVALID_EMAIL':
      return 'Seu e-mail é inválido.';
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'ERROR_INVALID_CREDENTIAL':
      return 'Seu e-mail é inválido.';
    case 'ERROR_WRONG_PASSWORD':
      return 'Sua senha está incorreta.';
    case userNotFound:
      return 'Não há usuário com este e-mail.';
    case 'ERROR_USER_DISABLED':
      return 'Este usuário foi desabilitado.';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'Operação não permitida.';
    default:
      return 'Um erro indefinido ocorreu.';
  }
}

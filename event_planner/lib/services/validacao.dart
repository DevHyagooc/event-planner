class Validators {
  static bool emailValido(String email) {
    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    return regex.hasMatch(email);
  }

  static bool senhaValida(
    String senha,
    String confirmarSenha,
  ) {
    return senha == confirmarSenha;
  }

  static bool cpfValido(String cpf) {
    return cpf.length == 14;
  }
}
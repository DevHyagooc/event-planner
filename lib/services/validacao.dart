class Validators {
  static bool emailValido(String email) {
    final regex = RegExp(
      r'^[\w\.-]+@souunit\.com\.br$',
    );

    return regex.hasMatch(
      email.trim().toLowerCase(),
    );
  }

  static bool senhaValida(
    String senha,
    String confirmarSenha,
  ) {
    return senha.length >= 6 &&
        senha == confirmarSenha;
  }

  static bool cpfValido(String cpf) {
    final numeros =
        cpf.replaceAll(RegExp(r'[^0-9]'), '');

    return numeros.length == 11;
  }
}
//para receber os dados do usuario logado
class Usuario {
  final String nome;
  final String email;
  final String telefone;
  final String endereco;

  Usuario({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.endereco,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      endereco: json['endereco'],
    );
  }
}

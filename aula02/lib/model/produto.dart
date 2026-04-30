class Produto {
  final int id;
  final String nome;
  final String descricao;
  final int categoria;
  final String imagem;
  final String marca;
  final String peso;
  final String codigoBarras;
  final int status;

  Produto({
    required this.nome,
    required this.codigoBarras,
    required this.categoria,
    this.imagem = '',
    this.marca = '',
    this.peso = '',
    this.descricao = '',
    this.status = 1,
    this.id = 0,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria_id'] ?? 0,
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      marca: json['marca'] ?? '',
      peso: json['peso'] ?? '',
      codigoBarras: json['codigo_barras'] ?? '0',
      status: json['ativo'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'categoria_id': categoria,
      'descricao': descricao,
      'imagem': imagem,
      'marca': marca,
      'peso': peso,
      'codigo_barras': codigoBarras,
      'ativo': status,
    };
  }
}


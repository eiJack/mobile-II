import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aula02/services/imagem_service.dart';

class SeletorImagem extends StatelessWidget {
  final File? imagemAtual;
  final ValueChanged<File> quandoImagemSelecionada;

  const SeletorImagem({
    super.key,
    required this.imagemAtual,
    required this.quandoImagemSelecionada,
  });

  Future<void> _abrirOpcoes(BuildContext context) async {
    final service = ImagemService();
    //opcao de selecionar imagem na galeria
    Future<void> selecionarImagemGaleria(context) async {
      Navigator.pop(context);
      final img = await service.pegarDaGaleria();
      if (img != null) quandoImagemSelecionada(img);
    }

    //quando escolher a camera
    Future<void> abrirCamera(context) async {
      Navigator.pop(context);
      final img = await service.tirarFoto();
      if (img != null) quandoImagemSelecionada(img);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () async => await abrirCamera(context),
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Galeria"),
              onTap: () async => await selecionarImagemGaleria(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //o primeiro elemento é o fundo
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(8),
            image: imagemAtual != null
                ? DecorationImage(image: FileImage(imagemAtual!))
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () => _abrirOpcoes(context),
            icon: Icon(Icons.edit),
          ),
        ),
      ],
    );
  }
}

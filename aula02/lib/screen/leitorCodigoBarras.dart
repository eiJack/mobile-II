import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class leitorCodigoBarras extends StatefulWidget {
  const leitorCodigoBarras({super.key});

  @override
  State<leitorCodigoBarras> createState() => _leitorCodigoBarrasState();
}

class _leitorCodigoBarrasState extends State<leitorCodigoBarras> {
  bool jaLeu = false;
  //---------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (capture) {
          if (jaLeu) return;
          final codigo = capture.barcodes.isNotEmpty
              ? capture.barcodes.first
              : null;
          final valor = codigo?.rawValue ?? '';
          jaLeu = true;
          if (valor.isEmpty) return;
          Navigator.of(context).pop(valor);
        },
      ),
    );
  }
}

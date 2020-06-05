import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfView(),
    );
  }
}

class PdfView extends StatefulWidget {
  @override
  _PdfViewState createState() => new _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String pathPDF = "";

  // @override
  // void initState() {
  //   super.initState();
  getDocument() async {
    // super.initState();
    await createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });
  }
  // }

  Future<File> createFileOfPdfUrl() async {
    // final url =
    //     "https://www.casasbahia-imagens.com.br/HotSite/2017/retira-rapido/images/PDF/Termo_Autoriza%C3%A7%C3%A3o_PF.pdf";
    // final url = "http://africau.edu/images/default/sample.pdf";
    // final url =
    //     "http://www.detran.rj.gov.br/_include/on_line/formularios/CJC0031_troca_de_real_infrator.pdf";
    final url = "http://www.conselhos.org.br/Arquivos/Download/Upload/116.pdf";
    // final url =
    //     "http://www.caixa.gov.br/Downloads/caixa-cartilhas/Termo_Unico_de_Responsabilidade_para_Adesao_ao_Servico_e_Mensagens_Via_Celular.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: RaisedButton(
          child: Text("Open PDF"),
          onPressed: () async {
            await getDocument();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
            );
          },
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}

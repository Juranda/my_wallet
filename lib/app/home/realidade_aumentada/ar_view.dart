import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ArView extends StatefulWidget {
  const ArView({super.key});

  @override
  State<ArView> createState() => _ArViewState();
}

class _ArViewState extends State<ArView> {
  late final WebViewController _controller;
  late int aluno_dinheiro;

  Future<void> _requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<List<Map<String, dynamic>>> getDinheiro() async {
    var response = await Supabase.instance.client
        .from('aluno')
        .select('dinheiro, usuario(fk_usuario_supabase)')
        .eq('usuario.fk_usuario_supabase',
            Supabase.instance.client.auth.currentUser!.id)
        .limit(1);
    return response;
  }

  // void initState() {
  //   super.initState();
  // }
  void initState() {
    super.initState();

    Permission.camera.request();

    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params,
            onPermissionRequest: (request) {
      if (request.types.contains(WebViewPermissionResourceType.microphone)) {
        request.deny();
      } else {
        request.grant();
      }
    });

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromARGB(0, 255, 255, 255))
      ..addJavaScriptChannel(
        "messageHandler",
        onMessageReceived: (JavaScriptMessage javaScriptMessage) {
          print("message from the web view=\"${javaScriptMessage.message}\"");
        },
      )
      ..loadRequest(
          Uri.parse('https://gabriel-ribeiro-v.github.io/ArJsThing/'));
    //..loadFlutterAsset('assets/ar/test.html');

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getDinheiro(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("Erro ao acessar dinheiro");
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                aluno_dinheiro =
                    (snapshot.data![0]['dinheiro'] as int).toDouble();
                _controller.runJavaScript('receiveMessageFromFlutter(${20});');
                return WebViewWidget(controller: _controller);
              },
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.runJavaScript("""
          navigator.mediaDevices.getUserMedia({video: true, audio: false})
            .then(mediaStream => {
              const stream = mediaStream;
              const tracks = stream.getTracks();

              tracks.forEach(track => track.stop())
            });""").catchError((error) => SnackBar(content: Text('Erro: ' + error)));
  }
}

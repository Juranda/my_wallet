import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> _requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
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
        'Toaster',
        onMessageReceived: (message) => SnackBar(
          content: Container(
            child: Text(
              message.message,
            ),
          ),
        ),
      )
      ..loadRequest(
          Uri.parse('https://gabriel-ribeiro-v.github.io/ArJsThing/'));

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return WebViewWidget(controller: _controller);
        },
      ),
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class DeezerLogin {
  Future<void> deezerLogin(BuildContext context) async {
    String deezerLoginHtmlPage =
        await rootBundle.loadString("assets/deezer/deezer_auth.html");
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(deezerLoginHtmlPage));
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (ctx) => DeezerLoginView(contentBase64)));
  }
}

class DeezerLoginView extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final String contentBase64;

  DeezerLoginView(this.contentBase64);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
//          SampleMenu(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'data:text/html;base64,$contentBase64',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _deezerAuthJavascriptChannel(context),
//            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
//          onPageFinished: (String url) {
//            print('Page finished loading: $url');
//          },
        );
      }),
    );
  }

  JavascriptChannel _deezerAuthJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'DeezerAuth',
        onMessageReceived: (JavascriptMessage message) {
          print("RECIEVED MESSAGE: ${message.message}");
          final decodedJson = jsonDecode(message.message);
          print("DECODED JSON");
//          Scaffold.of(context).showSnackBar(
//            SnackBar(content: Text(message.message)),
//          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}

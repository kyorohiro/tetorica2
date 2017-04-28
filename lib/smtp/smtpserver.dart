part of tet_smtp;


class SmtpServer {

  StreamController _controllerOnNewRequest = new StreamController.broadcast();
//  HetimaSocketBuilder _builder;
  String host;
  int port;
  TetServerSocket _serverSocket = null;

  SmtpServer._internal(TetServerSocket s) {
    _serverSocket = s;
  }

  void close() {
    if(_serverSocket != null) {
      _serverSocket.close();
      _serverSocket = null;
      _controllerOnNewRequest.close();
      _controllerOnNewRequest = null;
    }
  }

  static Future<SmtpServer> bind(TetSocketBuilder builder, String address, int port) {
    Completer<SmtpServer> completer = new Completer();
    builder.startServer(address, port).then((TetServerSocket serverSocket){
      if(serverSocket == null) {
        completer.completeError({});
        return;
      }
      SmtpServer server = new SmtpServer._internal(serverSocket);
      completer.complete(server);
      serverSocket.onAccept().listen((TetSocket socket){
        EasyParser parser = new EasyParser(socket.buffer);
//        HetiHttpResponse.decodeRequestMessage(parser).then((HetiHttpRequestMessageWithoutBody body){
//        });
      });
    }).catchError((e){
      completer.completeError(e);
    });
    return completer.future;
  }

  Stream<SmtpRequest> onNewRequest() {
    return _controllerOnNewRequest.stream;
  }
}

class SmtpRequest
{
  TetSocket socket;
//  HetiHttpRequestMessageWithoutBody info;
}

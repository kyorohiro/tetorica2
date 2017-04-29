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
        server._controllerOnNewRequest.add(new SmtpSession(socket));
//        HetiHttpResponse.decodeRequestMessage(parser).then((HetiHttpRequestMessageWithoutBody body){
//        });
      });
    }).catchError((e){
      completer.completeError(e);
    });
    return completer.future;
  }

  Stream<SmtpSession> onNewRequest() {
    return _controllerOnNewRequest.stream;
  }
}


class SmtpSession
{
  TetSocket socket;
  EasyParser parser;
  SmtpSession(this.socket) {
    this.parser = new EasyParser(socket.buffer);
  }

  Future<SmtpMessage>next() async {
    return SmtpMessage.decode(parser);
  }

  Stream<List<int>> load() {
   return SmtpMessage.decodeExceptDotStream(parser);
  }

  Future send(int code, String message,{withCRLF:true}){
    socket.send(convert.UTF8.encode("${code} $message ${(withCRLF?'\r\n':'')}"));
  }
  //  HetiHttpRequestMessageWithoutBody info;
}

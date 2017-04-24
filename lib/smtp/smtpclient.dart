part of tet_smtp;


class SmtpClient {
  TetSocketBuilder _socketBuilder;
  TetSocket socket = null;
  EasyParser parser = null;
  String host;
  int port;

  bool _verbose = false;

  SmtpClient(TetSocketBuilder socketBuilder, {HetimaDataBuilder dataBuilder: null, bool verbose: false}) {
    _socketBuilder = socketBuilder;
    _verbose = verbose;
  }

  Future connect(String _host, int _port, {bool useSecure: false}) async {
    host = _host;
    port = _port;
    socket = (useSecure ? _socketBuilder.createSecureClient() : _socketBuilder.createClient());
    parser = new EasyParser(socket.buffer);
    if (socket == null) {
      throw {};
    }
    log("<hetihttpclient f=connect> ${socket}");
    TetSocket s = await socket.connect(host, port);
    if (s == null) {
      throw {};
    }
    //return new HttpClientConnectResult();
  }

  Future sendHello(String domain) async {
    return await this.socket.send(convert.ASCII.encode("HELO ${domain}\r\n"));
  }

  Future sendEhlo(String domain) async {
    return await this.socket.send(convert.ASCII.encode("EHLO ${domain}\r\n"));
  }

  Future sendMailFrom(String from) async {
    return await this.socket.send(convert.ASCII.encode("MAIL FROM: ${from}\r\n"));
  }

  Future sendRcptTo(String to) async {
    return await this.socket.send(convert.ASCII.encode("RCPT TO: ${to}\r\n"));
  }

  Future sendData(List<int> data,{bool containEnd:false}) async {
    await this.socket.send(convert.ASCII.encode("DATA\r\n"));
    await this.socket.send(data);
    if(!containEnd) {
      await this.socket.send(convert.ASCII.encode("\r\n\r\n.\r\n"));
    }
  }

  Future sendQuit() async {
    return await this.socket.send(convert.ASCII.encode("QUIT--\r\n"));
  }

  Future readLine() async {
    ArrayBuilder builder = new ArrayBuilder();
    do {
      int b = await this.parser.readByte();
      if (b == 10) {
        this.parser.buffer.clearInnerBuffer(this.parser.index);
        break;
      } else {
        builder.appendByte(b);
      }
    } while(true);
    return builder.toList();
  }

  void log(String message) {
    if (_verbose) {
      print("++${message}");
    }
  }
}
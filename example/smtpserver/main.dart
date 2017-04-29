import 'package:tetorica/smtp.dart' as smtp;
import 'package:tetorica/net.dart' as net;
import 'package:tetorica/net_dartio.dart' as dartio;

main() async {
  net.TetSocketBuilder builder = new dartio.TetSocketBuilderDartIO();
  smtp.SmtpServer server = await smtp.SmtpServer.bind(builder, "0.0.0.0", 25);
  server.onNewRequest().listen((smtp.SmtpSession session) async {

    bool isLoop = true;
    bool isSession = false;
    String pDomain = "";
    String pFrom = "";
    List<String> pTos = [];
    do {
      smtp.SmtpMessage message = await session.next();
      switch(message.type) {
        case smtp.SmtpMessageType.helo:
          pDomain = message.value;
          session.send(250, "Hello");
          isSession = true;
          break;
        case smtp.SmtpMessageType.mail:
          pFrom = message.value;
          session.send(250, "OK");
          break;
        case smtp.SmtpMessageType.rcpt:
          pTos.add(message.value);
          session.send(250, "OK");
          break;
        case smtp.SmtpMessageType.data:

        case smtp.SmtpMessageType.rset:
        case smtp.SmtpMessageType.send:
        case smtp.SmtpMessageType.soml:
        case smtp.SmtpMessageType.saml:
        case smtp.SmtpMessageType.vrfy:
        case smtp.SmtpMessageType.expn:
        case smtp.SmtpMessageType.help:
        case smtp.SmtpMessageType.noop:
        case smtp.SmtpMessageType.turn:
          break;
        case smtp.SmtpMessageType.quit:
          isLoop = false;
          isSession = false;
          break;
      }
    } while(isLoop);
  });

}
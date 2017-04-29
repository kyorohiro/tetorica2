import 'package:tetorica/smtp.dart' as smtp;
import 'package:tetorica/net.dart' as net;
import 'package:tetorica/net_dartio.dart' as dartio;

main() async {
  net.TetSocketBuilder builder = new dartio.TetSocketBuilderDartIO();
  smtp.SmtpServer server = await smtp.SmtpServer.bind(builder, "0.0.0.0", 25);
  server.onNewRequest().listen((smtp.SmtpRequest req){
    req.next();
  });

}
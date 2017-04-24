import 'package:tetorica/net_dartio.dart' as tio;
import 'package:tetorica/net.dart' as tet;
import 'dart:convert' as conv;
import 'dart:async';

import 'package:tetorica/smtp.dart' as tsm;

main() async {
  tet.TetSocketBuilder builder = new tio.TetSocketBuilderDartIO(verbose: true);
  tsm.SmtpClient cl = new tsm.SmtpClient(builder);
  await cl.connect("mail.kyorohiro.info",25);
  await cl.sendHello("example.com");
  List<int> ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendMailFrom("test@example.com");
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendRcptTo("root@mail.kyorohiro.info");
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendData(conv.UTF8.encode("Subject: test\r\n\r\ntesttest\r\n"));
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

}
/*
main() async {
  tet.TetSocketBuilder builder = new tio.TetSocketBuilderDartIO();
  tet.TetSocket socket = builder.createSecureClient();
  await socket.connect("www.google.com", 443);

  socket.onReceive.listen((tet.TetReceiveInfo v){
  });
  await socket.send(conv.ASCII.encode("GET / HTTP/1.1 \r\n\r\n"));
  await new Future.delayed(new Duration(seconds: 5));
  print(conv.UTF8.decode(socket.buffer.toUint8List()));
}
*/
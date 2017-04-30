import 'package:tetorica/net_dartio.dart' as tio;
import 'package:tetorica/net.dart' as tet;
import 'dart:convert' as conv;
import 'dart:async';

import 'package:tetorica/smtp.dart' as tsm;

main() async {
  tet.TetSocketBuilder builder = new tio.TetSocketBuilderDartIO(verbose: true);
  tsm.SmtpClient cl = new tsm.SmtpClient(builder);
//  await cl.connect("mail.kyorohiro.info",25);
  await cl.connect("0.0.0.0",8025);
  print("conn");
  await cl.sendHello("example.com");
  print("h1");

  List<int> ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendMailFrom("test@example.com");
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendRcptTo("root@mail.kyorohiro.info");
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));

  await cl.sendData(conv.UTF8.encode("Subject: test\r\nFrom:test@example.com\r\n\r\ntesttest\r\n"));
  ret = await cl.readLine();
  print(conv.UTF8.decode(ret));
  cl.close();
}
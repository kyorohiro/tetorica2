import 'package:tetorica/net_dartio.dart' as tio;
import 'package:tetorica/net.dart' as tet;
import 'dart:convert' as conv;
import 'dart:async';

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

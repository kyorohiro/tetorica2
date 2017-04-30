part of tet_smtp;


enum SmtpMessageType {
  helo,
  mail,
  rcpt,
  data,
  rset,
  send,
  soml,
  saml,
  vrfy,
  expn,
  help,
  noop,
  quit,
  turn
}

typedef decodeFunc (EasyParser p);

class SmtpMessage {
  SmtpMessageType type;
  String value;

  SmtpMessage(){
  }

  SmtpMessage.quit() {
    type = SmtpMessageType.quit;
    value = "";
  }

  static List<decodeFunc> decodeFuncs =[
    SmtpMessage.decodeHello,
    SmtpMessage.decodeMail,
    SmtpMessage.decodeRcpt,
    SmtpMessage.decodeData,
    SmtpMessage.decodeRset,
    SmtpMessage.decodeSend,
    SmtpMessage.decodeSoml,
    SmtpMessage.decodeSaml,
    SmtpMessage.decodeVref,
    SmtpMessage.decodeExpn,
    SmtpMessage.decodeHelp,
    SmtpMessage.decodeNoop,
    SmtpMessage.decodeTurn,
  ];

  static Future<SmtpMessage> decode(EasyParser parser) async {
    for (decodeFunc f in decodeFuncs) {
      try {
        parser.push();
        return await f(parser);
      } catch (e) {
        parser.back();
      }finally {
        parser.pop();
      }
    }
    throw "";
  }

  //   HELO <SP> <domain> <CRLF>
  static Future<SmtpMessage> decodeHello(EasyParser parser) async {
    await parser.nextString("HELO ", checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);

    return new SmtpMessage()
      ..type  = SmtpMessageType.helo
      ..value = value;
  }

  // MAIL <SP> FROM:<reverse-path> <CRLF>
  static Future<SmtpMessage> decodeMail(EasyParser parser) async {
    await parser.nextString("MAIL FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.mail
      ..value = value;
  }

  // RCPT <SP> TO:<forward-path> <CRLF>
  static Future<SmtpMessage> decodeRcpt(EasyParser parser) async {
    await parser.nextString("RCPT TO:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.rcpt
      ..value = value;
  }

  // DATA <CRLF>
  static Future<SmtpMessage> decodeData(EasyParser parser) async {
    await parser.nextString("DATA",checkUpperLowerCase:true);
    await decodeCRLF(parser);

    return new SmtpMessage()
      ..type  = SmtpMessageType.data
      ..value = "";
  }

  // RSET <CRLF>
  static Future<SmtpMessage> decodeRset(EasyParser parser) async {
    await parser.nextString("RSET",checkUpperLowerCase:true);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.rset
      ..value = "";
  }

  // SEND <SP> FROM:<reverse-path> <CRLF>
  static Future<SmtpMessage> decodeSend(EasyParser parser) async {
    await parser.nextString("SEND FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.send
      ..value = value;
  }

  //  SOML <SP> FROM:<reverse-path> <CRLF>
  static Future<SmtpMessage> decodeSoml(EasyParser parser) async {
    await parser.nextString("SOML FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.soml
      ..value = value;
  }

  // SAML <SP> FROM:<reverse-path> <CRLF>
  static Future<SmtpMessage> decodeSaml(EasyParser parser) async {
    await parser.nextString("SAML FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.saml
      ..value = value;
  }

  // VRFY <SP> <string> <CRLF>
  static Future<SmtpMessage> decodeVref(EasyParser parser) async {
    await parser.nextString("VRFY FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.vrfy
      ..value = value;
  }


  // EXPN <SP> <string> <CRLF>
  static Future<SmtpMessage> decodeExpn(EasyParser parser) async {
    await parser.nextString("EXPN ",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.expn
      ..value = value;
  }


  // HELP [<SP> <string>] <CRLF>
  static Future<SmtpMessage> decodeHelp(EasyParser parser) async {
    await parser.nextString("HELP",checkUpperLowerCase:true);
    String value = "";
    try {
      await parser.nextString(" ");
      value = await decodeExceptCRLF(parser);
    } catch(e) {
    }
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.help
      ..value = value;
  }

  //  NOOP <CRLF>
  static Future<SmtpMessage> decodeNoop(EasyParser parser) async {
    await parser.nextString("NOOP",checkUpperLowerCase:true);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.noop
      ..value = "";
  }

  // QUIT <CRLF>
  static Future<SmtpMessage> decodeQUIT(EasyParser parser) async {
    await parser.nextString("QUIT",checkUpperLowerCase:true);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.quit
      ..value = "";
  }

  // TURN <CRLF>
  static Future<SmtpMessage> decodeTurn(EasyParser parser) async {
    await parser.nextString("Turn",checkUpperLowerCase:true);
    await decodeCRLF(parser);
    return new SmtpMessage()
      ..type  = SmtpMessageType.turn
      ..value = "";
  }

  static Future<String> decodeCRLF(EasyParser parser) async {
    return parser.nextString("\r\n");
  }

  static Future<String> decodeExceptCRLF(EasyParser parser) async {
    int index = parser.index;
    while(true) {
      try {
        parser.push();
        await parser.nextString("\r\n");
        parser.back();
        break;
      } catch(e){
      } finally {
        parser.pop();
      }
      await parser.nextBuffer(1);
    }
    return convert.UTF8.decode(await parser.buffer.getBytes(index,parser.index-index),allowMalformed: true);
  }

  static Future<List<int>> decodeExceptDot(EasyParser parser) async {
    return parser.nextBytePatternByUnmatch(new EasyParserStringMatcher("\r\n."));
  }

  static Stream<List<int>> decodeExceptDotStream(EasyParser parser) {
    StreamController<List<int>> controller = new StreamController<List<int>>();
    new Future(() async{
      while(true) {
        try {
          await parser.nextString("\r\n.");
          controller.close();
          break;
        } catch(e){
        }
        controller.add([await parser.nextBuffer(1)]);
      }
    });
    return controller.stream;
  }
}

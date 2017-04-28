part of tet_smtp;


class SmtpMessage {
  //   HELO <SP> <domain> <CRLF>
  static Future decodeHello(EasyParser parser) async {
    await parser.nextString("HELO ", checkUpperLowerCase:true);
    String domain = await decodeDomain(parser);
    await decodeCRLF(parser);
  }

  // MAIL <SP> FROM:<reverse-path> <CRLF>
  static Future decodeMail(EasyParser parser) async {
    await parser.nextString("MAIL FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  // RCPT <SP> TO:<forward-path> <CRLF>
  static Future decodeRcpt(EasyParser parser) async {
    await parser.nextString("MAIL TO:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  // DATA <CRLF>
  static Future decodeData(EasyParser parser) async {
    await parser.nextString("DATA",checkUpperLowerCase:true);
    await decodeCRLF(parser);
  }

  // RSET <CRLF>
  static Future decodeRSET(EasyParser parser) async {
    await parser.nextString("RSET",checkUpperLowerCase:true);
    await decodeCRLF(parser);
  }

  // SEND <SP> FROM:<reverse-path> <CRLF>
  static Future decodeSend(EasyParser parser) async {
    await parser.nextString("SEND FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  //  SOML <SP> FROM:<reverse-path> <CRLF>
  static Future decodeSOML(EasyParser parser) async {
    await parser.nextString("SOML FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  // SAML <SP> FROM:<reverse-path> <CRLF>
  static Future decodeSAML(EasyParser parser) async {
    await parser.nextString("SAML FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }
  
  // VRFY <SP> <string> <CRLF>
  static Future decodeVRFY(EasyParser parser) async {
    await parser.nextString("VRFY FROM:",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  // EXPN <SP> <string> <CRLF>
  static Future decodeEXPN(EasyParser parser) async {
    await parser.nextString("EXPN ",checkUpperLowerCase:true);
    String value = await decodeExceptCRLF(parser);
    await decodeCRLF(parser);
  }

  // HELP [<SP> <string>] <CRLF>
  static Future decodeHELP(EasyParser parser) async {
    await parser.nextString("HELP",checkUpperLowerCase:true);
    try {
      await parser.nextString(" ");
      String value = await decodeExceptCRLF(parser);
    } catch(e) {
    }
    await decodeCRLF(parser);
  }

  //  NOOP <CRLF>
  static Future decodeNOOP(EasyParser parser) async {
    await parser.nextString("NOOP",checkUpperLowerCase:true);
    await decodeCRLF(parser);
  }
  // QUIT <CRLF>
  static Future decodeQUIT(EasyParser parser) async {
    await parser.nextString("QUIT",checkUpperLowerCase:true);
    await decodeCRLF(parser);
  }

  // TURN <CRLF>
  static Future decodeTURN(EasyParser parser) async {
    await parser.nextString("TURN",checkUpperLowerCase:true);
    await decodeCRLF(parser);
  }

  static Future<String> decodeDomain(EasyParser parser) async {

  }

  static Future<String> decodeSP(EasyParser parser) async {
    return parser.nextString(" ");
  }

  static Future<String> decodeCRLF(EasyParser parser) async {
    return parser.nextString("\r\n");
  }

  static Future<String> decodeExceptCRLF(EasyParser parser) async {
    parser.nextBytePatternByUnmatch(new EasyParserStringMatcher("\r\n"));
    return parser.nextString("\r\n");
  }

}

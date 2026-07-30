import 'dart:io';
import 'package:test/test.dart';
import 'package:typed_soup/typed_soup.dart';
import 'package:typed_soup/src/xml_builder.dart';

void main() {
  group('Additional Coverage', () {
    test('TypedSoup.fromUrl coverage', () async {
      final server = await HttpServer.bind('localhost', 0);
      server.listen((req) {
        req.response
          ..headers.contentType = ContentType.html
          ..write('<html><body><h1 id="title">Hello</h1></body></html>')
          ..close();
      });

      final url = 'http://localhost:${server.port}';
      final ts = await TypedSoup.fromUrl(url);
      expect(ts.find('h1')!.string, 'Hello');

      await server.close();
    });

    test('xml_builder.dart edge cases', () {
      final doc1 = parseXmlToHtmlDocument(
        '<Root><![CDATA[cdata text]]></Root>',
      );
      expect(doc1.outerHtml.contains('cdata text'), isTrue);

      final doc2 = parseXmlToHtmlDocument('<Root><!-- comment text --></Root>');
      expect(doc2.outerHtml.contains('comment text'), isTrue);
    });

    test('extensions.dart additional cases', () {
      final html = '<div class="c1" id="i1">Text</div><div class="c2"></div>';
      final ts = html.parseSoup();

      final divs = ts.findAll('div');
      expect(divs.texts, ['Text', '']);

      final imgHtml = '<img src="a.png" /><img src="b.png" />';
      final imgTs = imgHtml.parseSoupFragment();
      expect(imgTs.findAll('img').srcs, ['a.png', 'b.png']);

      final div1 = ts.find('div')!;
      expect(div1.hasAttr('class'), isTrue);
      expect(div1.className, 'c1');

      // withClass and withAttr
      final withC2 = divs.withClass('c2');
      expect(withC2.length, 1);

      final withId = divs.withAttr('id', 'i1');
      expect(withId.length, 1);

      // pattern extension
      final p = RegExp('test');
      expect(p.asRegExp, isA<RegExp>());
      final strP = 'test';
      expect(strP.asRegExp, isA<RegExp>());
    });
  });
}

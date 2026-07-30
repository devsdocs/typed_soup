import 'dart:convert';
import 'package:test/test.dart';
import 'package:typed_soup/typed_soup.dart';

void main() {
  group('TypedSoup New Features', () {
    test('fromBytes parses UTF-8 correctly', () {
      final bytes = utf8.encode('<html><body><p>Hello world</p></body></html>');
      final ts = TypedSoup.fromBytes(bytes);
      expect(ts.p?.string, 'Hello world');
    });

    test('xml parses XML correctly preserving case', () {
      final xmlString = '<Root><ChildItem id="1">Text</ChildItem></Root>';
      final ts = TypedSoup.xml(xmlString);

      // html.parse would lowercase to <root><childitem>. Our xml builder preserves structure (though Dart HTML element names are technically lowercase strings sometimes, but let's check).
      expect(ts.findWhere((e) => e.name == 'ChildItem')?.string, 'Text');
      expect(ts.findWhere((e) => e.name == 'ChildItem')?.id, '1');
    });

    test('custom selectors :contains and :has', () {
      final htmlString =
          '<html><body><div class="test">Hello</div><div class="test">World</div><div class="parent"><span class="child">SpanText</span></div></body></html>';
      final ts = TypedSoup(htmlString);

      // Test :contains
      final containsRes = ts.findAll('div', selector: 'div:contains(Hello)');
      expect(containsRes.length, 1);
      expect(containsRes.first.string, 'Hello');

      // Test :has
      final hasRes = ts.findAll('div', selector: 'div:has(.child)');
      expect(hasRes.length, 1);
      expect(hasRes.first.className, 'parent');
    });

    test('xpath query', () {
      final htmlString =
          '<html><body><div><p id="p1">First</p><p id="p2">Second</p></div></body></html>';
      final ts = TypedSoup(htmlString);

      final res = ts.xpath('//p[@id="p2"]');
      expect(res.length, 1);
      expect(res.first.string, 'Second');
    });

    test('sanitize HTML', () {
      final htmlString =
          '<div><script>alert("XSS")</script><p>Safe content</p></div>';
      final ts = TypedSoup.fragment(htmlString);
      final div = ts.div!;
      div.sanitize();
      expect(div.outerHtml, '<div><p>Safe content</p></div>');
    });

    test('toMarkdown', () {
      final html =
          '<div><h1>Title</h1><p><b>Bold</b> and <a href="https://example.com">link</a></p><ul><li>Item 1</li></ul></div>';
      final ts = TypedSoup.fragment(html);
      final div = ts.div!;
      final md = div.toMarkdown();

      expect(md.contains('Title\n====='), true);
      expect(md.contains('**Bold**'), true);
      expect(md.contains('[link](https://example.com)'), true);
      expect(md.contains('*   Item 1'), true);
    });
    test('SoupStrainer memory-efficient parsing', () {
      final htmlStr =
          '<html><body><div>First</div><p>Ignore</p><div class="inner"><div>Nested</div></div><div>Last</div></body></html>';
      final strainer = SoupStrainer('div');
      final elements = strainer.strain(htmlStr).toList();

      expect(elements.length, 3);
      expect(elements[0].string, 'First');
      expect(elements[1].className, 'inner');
      expect(elements[1].children.length, 1); // Nested div is inside
      expect(elements[2].string, 'Last');
    });

    test('cssPath and xpathPath', () {
      final html =
          '<html><body><div id="main"><p class="p1">One</p><p class="p2">Two <a href="#">Link</a></p></div></body></html>';
      final ts = TypedSoup(html);

      final link = ts.find('a')!;
      expect(link.cssPath(), '#main > p:nth-child(2) > a');
      expect(link.xpathPath(), '//div[@id="main"]/p[2]/a');

      final p1 = ts.find('p', class_: 'p1')!;
      expect(p1.cssPath(), '#main > p:nth-child(1)');
      expect(p1.xpathPath(), '//div[@id="main"]/p[1]');

      final div = ts.find('div')!;
      expect(div.cssPath(), '#main');
      expect(div.xpathPath(), '//div[@id="main"]');
    });

    test('extractData JSON Schema Extraction', () {
      final html = '''
        <div class="product">
          <h1 id="title">Awesome Shirt</h1>
          <span class="price">\$19.99</span>
          <img src="shirt.png" class="preview" />
        </div>
      ''';
      final ts = TypedSoup(html);

      final data = ts.extractData({
        'productName': 'h1#title',
        'cost': '.price',
        'image': 'img.preview@src',
        'missing': '.does-not-exist',
      });

      expect(data['productName'], 'Awesome Shirt');
      expect(data['cost'], '\$19.99');
      expect(data['image'], 'shirt.png');
      expect(data['missing'], null);
    });

    test('TypedSoup.batch concurrent processing', () async {
      final htmls = [
        '<div>Page 1</div>',
        '<div>Page 2</div>',
        '<div>Page 3</div>',
      ];
      final results = await TypedSoup.batch(htmls);

      expect(results.length, 3);
      expect(results[0].text, 'Page 1');
      expect(results[1].text, 'Page 2');
      expect(results[2].text, 'Page 3');
    });

    test('xpath query invalid syntax coverage', () {
      final ts = TypedSoup('<div>hello</div>');
      final result = ts.xpath('////invalid[');
      expect(result, isEmpty);
    });

    test('SoupStrainer prefix tag coverage', () {
      final html = '<diva>Not a div</diva><div>Real div</div>';
      final strainer = SoupStrainer('div');
      final elements = strainer.strain(html).toList();
      expect(elements.length, 1);
      expect(elements[0].string, 'Real div');
    });

    test('SoupStrainer malformed tag coverage', () {
      final html = '<div>unclosed';
      final strainer = SoupStrainer('div');
      final elements = strainer.strain(html).toList();
      expect(elements.length, 0);
    });
  });
}

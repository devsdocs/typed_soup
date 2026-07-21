import 'package:typed_soup/typed_soup.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';

void main() {
  late TypedSoup ts;

  setUp(() {
    ts = TypedSoup(html_doc);
  });

  group('Element', () {
    group('name', () {
      test('finds name by tag', () {
        final elem = ts.title;

        expect(elem, isNotNull);
        expect(elem!.name, 'title');
      });

      test('finds name by find', () {
        final elem = ts.find('title');

        expect(elem, isNotNull);
        expect(elem!.name, 'title');
      });
    });

    group('outerHtml', () {
      test('finds outerHtml', () {
        final elem = ts.p;

        expect(elem, isNotNull);
        expect(
          elem!.outerHtml,
          equals("<p class=\"title\"><b>The Dormouse's story</b></p>"),
        );
      });
    });

    group('innerHtml', () {
      test('finds innerHtml', () {
        final elem = ts.p;

        expect(elem, isNotNull);
        expect(elem!.innerHtml, equals("<b>The Dormouse's story</b>"));
      });

      test('does not find innerHtml (empty string)', () {
        ts = TypedSoup.fragment(html_placeholder_empty);
        final elem = ts.findFirstAny();

        expect(elem, isNotNull);
        expect(elem!.innerHtml, equals(''));
      });
    });

    group('className', () {
      test('finds className', () {
        final elem = ts.p;

        expect(elem, isNotNull);
        expect(elem!.className, 'title');
      });

      test('does not find className (empty string)', () {
        final elem = ts.title;

        expect(elem, isNotNull);
        expect(elem!.className, '');
      });
    });

    group('id', () {
      test('finds id', () {
        final elem = ts.body?.a;

        expect(elem, isNotNull);
        expect(elem!.id, 'link1');
      });

      test('does not find id (empty string)', () {
        final elem = ts.title;

        expect(elem, isNotNull);
        expect(elem!.id, '');
      });
    });

    group('operator [], for attribute value getter', () {
      test('finds attribute value', () {
        final attr = ts.body?.a?['href'];

        expect(attr, isNotNull);
        expect(attr!, equals('http://example.com/elsie'));
      });

      test('does not find attribute value', () {
        final attr = ts.body?.a?['style'];
        expect(attr, isNull);
      });
    });

    group('hasAttr', () {
      test('finds attribute', () {
        final elem = ts.body?.a;

        expect(elem, isNotNull);
        expect(elem!.hasAttr('href'), isTrue);
        expect(elem.hasAttr('class'), isTrue);
        expect(elem.hasAttr('id'), isTrue);
        expect(elem.hasAttr('article'), isFalse);
      });

      test('does not find attribute', () {
        final elem = ts.title;
        expect(elem?.hasAttr('name'), isFalse);
      });
    });

    group('getAttrValue', () {
      test('finds attribute', () {
        ts = TypedSoup.fragment('<b id="boldest">bold</b>');
        final elem = ts.findFirstAny();

        expect(elem, isNotNull);
        expect(elem!.getAttrValue('id'), equals('boldest'));
        expect(elem['id'], equals('boldest'));
      });
    });
  });
}

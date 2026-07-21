import 'package:typed_soup/typed_soup.dart';
import 'package:typed_soup/src/helpers.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';

void main() {
  late TypedSoup ts;

  setUp(() {
    ts = TypedSoup(html_doc);
  });

  group('Extensions', () {
    group('TsElement from html.Element', () {
      test('parsing fragment does not add html tag', () {
        final elem = parse(html_doc).querySelector('p')?.ts;
        expect(elem, isNotNull);
        expect(elem!.name, equals('p'));
      });

      test('parsing html has html tag', () {
        final elem = parse(html_doc).querySelector('*')?.ts;
        expect(elem, isNotNull);
        expect(elem!.name, equals('html'));
        expect(elem.children.first.name, equals('head'));
      });
    });
  });

  group('Helpers', () {
    group('recursiveSearch', () {
      test('finds all recursively', () {
        final elem = ts.body;
        expect(elem, isNotNull);

        // body has 3 elements
        expect(elem!.children.length, 3);

        // recursive search gets also nested, deep ones
        final recursive = recursiveSearch(elem).toList();
        expect(recursive.length, 9);
      });
    });
  });
}

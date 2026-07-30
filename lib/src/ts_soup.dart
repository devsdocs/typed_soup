// ignore_for_file: non_constant_identifier_names

import 'package:typed_soup/src/ts_element.dart';
import 'package:typed_soup/src/extensions.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:typed_soup/src/xml_builder.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'shared.dart';

/// {@template bs_soup}
/// Typed Soup is a library for pulling data out of HTML files.
/// It provides ways of navigating, searching, and modifying the parse tree.
/// It commonly saves programmers hours or days of work.
///
/// How it should be used? 3 easy steps.
///
/// **1.** parse a document
///
/// ```
/// TypedSoup ts = TypedSoup(html_doc_string);
/// TypedSoup ts = TypedSoup.fragment(html_doc_string); // if it is just a part of html
/// ```
///
/// **2.** navigate quickly to any element
///
/// ```
/// TsElement elem = ts.body.p; // quickly with tags
/// TsElement elem = ts.find('p', class_: 'story'); // finds first element with html tag "p" and which has "class" attribute with value "story"
/// TsElement elem = ts.findAll('a', attrs: {'class': true}); // finds all elements with html tag "a" and which have defined "class" attribute with whatever value
/// TsElement elem = ts.find('', selector: '#link1'); // find with custom CSS selector (other parameters are ignored)
/// TsElement elem = ts.find('*', id: 'link1'); // find by id
/// TsElement elem = ts.find('*', regex: r'^b'); // find any element which tag starts with "b", for example: body, b, ...
/// TsElement elem = ts.find('p', string: r'^Article #\d*'); // find "p" element which text starts with "Article #[number]"
/// TsElement elem = ts.find('a', attrs: {'href': 'http://example.com/elsie'}); // finds by "href" attribute
/// ```
///
/// **3.** perform any actions
///
/// ```
/// elem.name; // get tag name
/// elem.string; // get text
/// elem.toString(); // get String representation of this element, same as outerHtml
/// elem.innerHtml; // get html elements inside the element
/// elem.className; // get class attribute value
/// elem['class']; // get class attribute value
/// elem['class'] = 'board'; // change class attribute value to 'board'
/// elem.children; // get all element's children elements
/// elem.replaceWith(otherTsElement); // replace with other element
/// ```
///
/// and many more!
/// {@endtemplate}
class TypedSoup extends Shared {
  /// {@macro bs_soup}
  TypedSoup(String html_doc) {
    doc = parse(html_doc);
  }

  /// {@macro bs_soup}
  TypedSoup.fragment(String html_doc) {
    doc = parseFragment(html_doc);
  }

  /// Parses an XML string preserving case-sensitivity and structure.
  TypedSoup.xml(String xml_doc) {
    doc = parseXmlToHtmlDocument(xml_doc);
  }

  /// Fetches an HTML document from the provided [url] and parses it.
  static Future<TypedSoup> fromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    return TypedSoup(response.body);
  }

  /// Parses HTML from bytes, decoding with UTF-8 and allowing malformed characters.
  TypedSoup.fromBytes(List<int> bytes) {
    final htmlStr = utf8.decode(bytes, allowMalformed: true);
    doc = parse(htmlStr);
  }

  /// {@macro tree_modifier_newTag}
  static TsElement newTag(
    String? name, {
    Map<String, String>? attrs,
    String? string,
  }) {
    final newElement = Element.tag(name);
    if (attrs != null) {
      newElement.attributes.addAll(attrs);
    }
    newElement.text = string;
    return newElement.ts;
  }

  /// Evaluates an XPath expression on this document and returns matching elements.
  List<TsElement> xpath(String query) {
    try {
      final xp = HtmlXPath.html(doc.outerHtml);
      final result = xp.query(query);
      return result.nodes
          .map((n) => n.node)
          .whereType<Element>()
          .map((e) => e.ts)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Batch parses a list of HTML strings concurrently using Dart Isolates.
  /// This prevents the main thread from blocking when processing massive numbers of pages.
  static Future<List<TypedSoup>> batch(List<String> htmlDocuments) async {
    final futures = htmlDocuments.map((html) {
      return Isolate.run(() => TypedSoup(html));
    });
    return Future.wait(futures);
  }

  @override
  String toString() => doc.outerHtml;
}

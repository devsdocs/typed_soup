// ignore_for_file: non_constant_identifier_names

import 'package:typed_soup/src/ts_element.dart';
import 'package:typed_soup/src/extensions.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

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

  @override
  String toString() => doc.outerHtml;
}

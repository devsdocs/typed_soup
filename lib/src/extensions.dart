import 'package:html/dom.dart';

import 'ts_element.dart';
import 'ts_soup.dart';

/// Extension for [Element].
extension ElementExt on Element {
  /// Returns [TsElement] from the [Element] ([which comes from
  /// `html` Dart package](https://pub.dev/packages/html)).
  TsElement get ts => TsElement(this);
}

/// Extension for [String] for convenient parsing.
extension StringSoupExt on String {
  /// Parses this HTML string into a [TypedSoup] document.
  TypedSoup parseSoup() => TypedSoup(this);

  /// Parses this HTML string into a [TypedSoup] fragment.
  TypedSoup parseSoupFragment() => TypedSoup.fragment(this);
}

/// Extension for [List<TsElement>] for convenient collection operations.
extension TsElementListExt on List<TsElement> {
  /// Extracts all non-null `href` attribute values.
  List<String> get hrefs => map((e) => e.href).whereType<String>().toList();

  /// Extracts all non-null `src` attribute values.
  List<String> get srcs => map((e) => e.src).whereType<String>().toList();

  /// Extracts full text strings from all elements.
  List<String> get texts => map((e) => e.text).toList();

  /// Extracts trimmed text strings from all elements.
  List<String> get trimmedTexts => map((e) => e.trimmedText).toList();

  /// Filters elements that contain the specified CSS [className].
  List<TsElement> withClass(String className) =>
      where((e) => e.classes.contains(className)).toList();

  /// Filters elements that have specified attribute [name] (and optional [value]).
  List<TsElement> withAttr(String name, [String? value]) =>
      where((e) => value == null ? e.hasAttr(name) : e[name] == value).toList();
}

/// Extensions for [Node].
extension NodeExt on Node {
  /// Gets the [String] (data) representation of this [Node].
  ///
  /// Usually outputs: doc comments, element tags, part of strings, ...
  String get data => _getDataFromNode(this);

  String _getDataFromNode(Node node) {
    switch (node.nodeType) {
      case Node.ELEMENT_NODE:
        return (node as Element).outerHtml;
      case Node.TEXT_NODE:
        return (node as Text).text;
      case Node.COMMENT_NODE:
        final data = (node as Comment).data;
        return '<!--$data-->';
      case Node.DOCUMENT_NODE:
        return (node as Document).outerHtml;
      case Node.DOCUMENT_TYPE_NODE:
        return (node as DocumentType).toString();
      case Node.DOCUMENT_FRAGMENT_NODE:
        return (node as DocumentFragment).outerHtml;
      case Node.ATTRIBUTE_NODE:
      case Node.CDATA_SECTION_NODE:
      case Node.ENTITY_REFERENCE_NODE:
      case Node.ENTITY_NODE:
      case Node.PROCESSING_INSTRUCTION_NODE:
      case Node.NOTATION_NODE:
        return node.toString();
      default:
        return node.toString();
    }
  }
}

///
extension PatternExt on Pattern {
  ///
  RegExp get asRegExp => this is RegExp ? this as RegExp : RegExp(toString());
}

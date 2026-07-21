import 'dart:collection';

import 'package:html/dom.dart';

import '../ts_element.dart';

/// Most of the implementation comes from [`html` Dart package](https://pub.dev/packages/html).
abstract class IElement {
  /// {@template TsElement_name}
  /// Getter/setter of the **tag name** of the element.
  ///
  /// Same as [element.localName].
  /// {@endtemplate}
  String? get name;

  /// Returns a fragment of HTML or XML that represents the element and its
  /// contents.
  ///
  /// Copied from [Element].
  String get outerHtml;

  /// Returns a fragment of HTML or XML that represents the element's contents.
  ///
  /// Can be set, to replace the contents of the element with nodes parsed from
  /// the given string.
  ///
  /// Copied from [Element].
  String get innerHtml;

  set innerHtml(String value);

  /// Getter/setter for the value of the `class` attribute.
  ///
  /// [DOM Element - className](http://dom.spec.whatwg.org/#dom-element-classname)
  String get className;

  set className(String value);

  /// Getter/setter for the value of the `id` attribute.
  ///
  /// [DOM Element - id](http://dom.spec.whatwg.org/#dom-element-id)
  String get id;

  set id(String value);

  /// [LinkedHashMap] getter/setter of the element's attributes.
  ///
  /// Where `key` is an attribute name and value is the `value` of an attribute.
  LinkedHashMap<Object, String> get attributes;

  set attributes(LinkedHashMap<Object, String> attributes);

  /// The set of CSS classes applied to this element.
  ///
  /// This set makes it easy to add, remove or toggle the classes applied to
  /// this element.
  ///
  ///     ts.classes.add('selected');
  ///     ts.classes.toggle('isOnline');
  ///     ts.classes.remove('selected');
  ///
  /// Copied from [Element].
  CssClassSet get classes;

  /// Returns the list of [Node]s.
  ///
  /// Can be used to iterate not only elements, but also doc comments, strings, etc.
  NodeList get nodes;

  /// Move all the children of the current node to [newParent].
  /// This is needed so that trees that don't store text as nodes move the
  /// text in the correct way.
  ///
  /// Copied from [Element].
  void reparentChildren(Node newParent);

  /// Returns a copy of this node.
  ///
  /// If deep is `true`, then all of this node's children and descendants are
  /// copied as well. If deep is `false`, then only this node is copied.
  ///
  /// Copied from [Element].
  TsElement clone(bool deep);

  /// {@template TsElement_getAttr}
  /// Gets an attribute value by [name].
  ///
  /// Returns `null` if attribute does not exist.
  /// {@endtemplate}
  String? operator [](String name);

  /// {@macro TsElement_getAttr}
  String? getAttrValue(String name);

  /// Returns `true` if the element has defined this attribute.
  bool hasAttr(String name);

  /// Gets an attribute value by [name] with optional default.
  ///
  /// Returns [defaultValue] if attribute does not exist.
  String? get(String name, {String? defaultValue});

  // Convenience Attribute Accessors

  /// Getter/setter for `href` attribute.
  String? get href;
  set href(String? value);

  /// Getter/setter for `src` attribute.
  String? get src;
  set src(String? value);

  /// Getter/setter for `alt` attribute.
  String? get alt;
  set alt(String? value);

  /// Getter/setter for `value` attribute.
  String? get value;
  set value(String? value);

  /// Getter/setter for `type` attribute.
  String? get type;
  set type(String? value);

  /// Getter/setter for `target` attribute.
  String? get target;
  set target(String? value);

  /// Getter/setter for `action` attribute.
  String? get action;
  set action(String? value);

  /// Returns trimmed text content of the element.
  String get trimmedText;

  /// Returns `true` if this element contains a matching child for [selector].
  bool hasChild(String selector);

  /// Returns direct child elements matching [tagName].
  List<TsElement> childrenByTag(String tagName);

  /// Converts an HTML table element into a list of row maps.
  ///
  /// Uses header cells (`<th>` or first row `<td>`) as map keys.
  List<Map<String, String>> toTableData();

  /// Gets value of a `data-*` attribute by key name (e.g. `user-id` or `data-user-id`).
  String? dataAttr(String name);

  /// Returns a map of all `data-*` attributes present on this element.
  Map<String, String> get dataAttrs;

  /// Returns the closest ancestor element (including self) matching [selector].
  TsElement? closest(String selector);

  /// Returns `true` if this element matches the given CSS [selector].
  bool matches(String selector);

  /// Returns a list of text lines with leading/trailing whitespace removed and empty lines excluded.
  List<String> get strippedLines;

  /// Returns text that belongs ONLY to this element directly (excluding nested child elements).
  String get ownText;

  /// Returns trimmed text that belongs ONLY to this element directly.
  String get ownTextTrimmed;

  /// Extracts form input names and values into a Map&lt;String, String&gt;.
  Map<String, String> toFormData();
}

import '../ts_element.dart';

/// Contains most common tags and collection getters for quick and easy navigating
/// down the parse tree.
abstract class ITags {
  /// {@template tags_common_tag}
  /// Returns the first occurrence of this tag down the parse tree.
  /// {@endtemplate}
  TsElement? get html;

  /// {@macro tags_common_tag}
  TsElement? get head;

  /// {@macro tags_common_tag}
  TsElement? get body;

  /// {@macro tags_common_tag}
  TsElement? get title;

  /// {@macro tags_common_tag}
  TsElement? get h1;

  /// {@macro tags_common_tag}
  TsElement? get h2;

  /// {@macro tags_common_tag}
  TsElement? get h3;

  /// {@macro tags_common_tag}
  TsElement? get h4;

  /// {@macro tags_common_tag}
  TsElement? get h5;

  /// {@macro tags_common_tag}
  TsElement? get h6;

  /// {@macro tags_common_tag}
  TsElement? get p;

  /// {@macro tags_common_tag}
  TsElement? get a;

  /// {@macro tags_common_tag}
  TsElement? get b;

  /// {@macro tags_common_tag}
  TsElement? get i;

  /// {@macro tags_common_tag}
  TsElement? get img;

  /// {@macro tags_common_tag}
  TsElement? get table;

  /// {@macro tags_common_tag}
  TsElement? get ul;

  /// {@macro tags_common_tag}
  TsElement? get ol;

  /// {@macro tags_common_tag}
  TsElement? get dl;

  /// {@macro tags_common_tag}
  TsElement? get div;

  /// {@macro tags_common_tag}
  TsElement? get span;

  /// {@macro tags_common_tag}
  TsElement? get form;

  /// {@macro tags_common_tag}
  TsElement? get input;

  /// {@macro tags_common_tag}
  TsElement? get button;

  /// {@macro tags_common_tag}
  TsElement? get label;

  /// {@macro tags_common_tag}
  TsElement? get selectTag;

  /// {@macro tags_common_tag}
  TsElement? get textarea;

  /// {@macro tags_common_tag}
  TsElement? get section;

  /// {@macro tags_common_tag}
  TsElement? get article;

  /// {@macro tags_common_tag}
  TsElement? get header;

  /// {@macro tags_common_tag}
  TsElement? get footer;

  /// {@macro tags_common_tag}
  TsElement? get nav;

  /// {@macro tags_common_tag}
  TsElement? get main;

  /// {@macro tags_common_tag}
  TsElement? get li;

  /// {@macro tags_common_tag}
  TsElement? get tr;

  /// {@macro tags_common_tag}
  TsElement? get td;

  /// {@macro tags_common_tag}
  TsElement? get th;

  /// {@macro tags_common_tag}
  TsElement? get code;

  /// {@macro tags_common_tag}
  TsElement? get pre;

  /// {@macro tags_common_tag}
  TsElement? get iframe;

  // Plural Collection Getters

  /// Returns all `<a>` elements down the parse tree.
  List<TsElement> get links;

  /// Returns all `<p>` elements down the parse tree.
  List<TsElement> get paragraphs;

  /// Returns all `<img>` elements down the parse tree.
  List<TsElement> get imgs;

  /// Returns all `<div>` elements down the parse tree.
  List<TsElement> get divs;

  /// Returns all `<span>` elements down the parse tree.
  List<TsElement> get spans;

  /// Returns all `<button>` elements down the parse tree.
  List<TsElement> get buttons;

  /// Returns all `<input>` elements down the parse tree.
  List<TsElement> get inputs;

  /// Returns all `<form>` elements down the parse tree.
  List<TsElement> get forms;

  /// Returns all `<table>` elements down the parse tree.
  List<TsElement> get tables;

  /// Returns all `<tr>` elements down the parse tree.
  List<TsElement> get rows;

  /// Returns all `<td>` and `<th>` elements down the parse tree.
  List<TsElement> get cells;

  /// Returns all `<li>` elements down the parse tree.
  List<TsElement> get items;

  /// Returns all heading elements (`<h1>`–`<h6>`) down the parse tree.
  List<TsElement> get headings;
}

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

  /// {@macro tags_common_tag}
  TsElement? get strong;

  /// {@macro tags_common_tag}
  TsElement? get em;

  /// {@macro tags_common_tag}
  TsElement? get u;

  /// {@macro tags_common_tag}
  TsElement? get blockquote;

  /// {@macro tags_common_tag}
  TsElement? get br;

  /// {@macro tags_common_tag}
  TsElement? get hr;

  /// {@macro tags_common_tag}
  TsElement? get small;

  /// {@macro tags_common_tag}
  TsElement? get mark;

  /// {@macro tags_common_tag}
  TsElement? get sub;

  /// {@macro tags_common_tag}
  TsElement? get sup;

  /// {@macro tags_common_tag}
  TsElement? get dt;

  /// {@macro tags_common_tag}
  TsElement? get dd;

  /// {@macro tags_common_tag}
  TsElement? get thead;

  /// {@macro tags_common_tag}
  TsElement? get tbody;

  /// {@macro tags_common_tag}
  TsElement? get tfoot;

  /// {@macro tags_common_tag}
  TsElement? get caption;

  /// {@macro tags_common_tag}
  TsElement? get option;

  /// {@macro tags_common_tag}
  TsElement? get fieldset;

  /// {@macro tags_common_tag}
  TsElement? get aside;

  /// {@macro tags_common_tag}
  TsElement? get figure;

  /// {@macro tags_common_tag}
  TsElement? get figcaption;

  /// {@macro tags_common_tag}
  TsElement? get details;

  /// {@macro tags_common_tag}
  TsElement? get summary;

  /// {@macro tags_common_tag}
  TsElement? get video;

  /// {@macro tags_common_tag}
  TsElement? get audio;

  /// {@macro tags_common_tag}
  TsElement? get script;

  /// {@macro tags_common_tag}
  TsElement? get style;

  /// {@macro tags_common_tag}
  TsElement? get linkTag;

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

  /// Returns all `<strong>` elements down the parse tree.
  List<TsElement> get strongs;

  /// Returns all `<em>` elements down the parse tree.
  List<TsElement> get ems;

  /// Returns all `<u>` elements down the parse tree.
  List<TsElement> get us;

  /// Returns all `<blockquote>` elements down the parse tree.
  List<TsElement> get blockquotes;

  /// Returns all `<br>` elements down the parse tree.
  List<TsElement> get brs;

  /// Returns all `<hr>` elements down the parse tree.
  List<TsElement> get hrs;

  /// Returns all `<small>` elements down the parse tree.
  List<TsElement> get smalls;

  /// Returns all `<mark>` elements down the parse tree.
  List<TsElement> get marks;

  /// Returns all `<sub>` elements down the parse tree.
  List<TsElement> get subs;

  /// Returns all `<sup>` elements down the parse tree.
  List<TsElement> get sups;

  /// Returns all `<dt>` elements down the parse tree.
  List<TsElement> get dts;

  /// Returns all `<dd>` elements down the parse tree.
  List<TsElement> get dds;

  /// Returns all `<thead>` elements down the parse tree.
  List<TsElement> get theads;

  /// Returns all `<tbody>` elements down the parse tree.
  List<TsElement> get tbodys;

  /// Returns all `<tfoot>` elements down the parse tree.
  List<TsElement> get tfoots;

  /// Returns all `<caption>` elements down the parse tree.
  List<TsElement> get captions;

  /// Returns all `<option>` elements down the parse tree.
  List<TsElement> get options;

  /// Returns all `<fieldset>` elements down the parse tree.
  List<TsElement> get fieldsets;

  /// Returns all `<aside>` elements down the parse tree.
  List<TsElement> get asides;

  /// Returns all `<figure>` elements down the parse tree.
  List<TsElement> get figures;

  /// Returns all `<figcaption>` elements down the parse tree.
  List<TsElement> get figcaptions;

  /// Returns all `<details>` elements down the parse tree.
  List<TsElement> get detailsList;

  /// Returns all `<summary>` elements down the parse tree.
  List<TsElement> get summaries;

  /// Returns all `<video>` elements down the parse tree.
  List<TsElement> get videos;

  /// Returns all `<audio>` elements down the parse tree.
  List<TsElement> get audios;

  /// Returns all `<script>` elements down the parse tree.
  List<TsElement> get scripts;

  /// Returns all `<style>` elements down the parse tree.
  List<TsElement> get styles;

  /// Returns all `<link>` elements down the parse tree.
  List<TsElement> get linkTags;
}

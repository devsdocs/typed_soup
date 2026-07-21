import 'package:html/dom.dart';

import 'ts_element.dart';
import 'ts_soup.dart';
import 'extensions.dart';
import 'interface/interface.dart';

///
class Tags implements ITags {
  ///
  Element? element;
  Document? _doc;
  DocumentFragment? _docFragment;

  /// Returns [Document] or [DocumentFragment], based on what parser was used
  /// with the [TypedSoup] constructor.
  ///
  /// This should not be used publicly along with setter.
  ///
  /// Can return null.
  dynamic get doc => _doc ?? _docFragment;

  set doc(dynamic value) {
    if (value is Document) {
      _doc = value;
      _docFragment = null;
    } else {
      _docFragment = value;
      _doc = null;
    }
  }

  TsElement? _findFirst(String tagName) =>
      ((element ?? doc).querySelector(tagName) as Element?)?.ts;

  List<TsElement> _findAll(String selector) =>
      ((element ?? doc).querySelectorAll(selector) as List<Element>)
          .map((e) => e.ts)
          .toList();

  @override
  TsElement? get html => _findFirst('html');

  @override
  TsElement? get body => _findFirst('body');

  @override
  TsElement? get head => _findFirst('head');

  @override
  TsElement? get a => _findFirst('a');

  @override
  TsElement? get b => _findFirst('b');

  @override
  TsElement? get i => _findFirst('i');

  @override
  TsElement? get p => _findFirst('p');

  @override
  TsElement? get title => _findFirst('title');

  @override
  TsElement? get h1 => _findFirst('h1');

  @override
  TsElement? get h2 => _findFirst('h2');

  @override
  TsElement? get h3 => _findFirst('h3');

  @override
  TsElement? get h4 => _findFirst('h4');

  @override
  TsElement? get h5 => _findFirst('h5');

  @override
  TsElement? get h6 => _findFirst('h6');

  @override
  TsElement? get img => _findFirst('img');

  @override
  TsElement? get table => _findFirst('table');

  @override
  TsElement? get dl => _findFirst('dl');

  @override
  TsElement? get ul => _findFirst('ul');

  @override
  TsElement? get ol => _findFirst('ol');

  @override
  TsElement? get div => _findFirst('div');

  @override
  TsElement? get span => _findFirst('span');

  @override
  TsElement? get form => _findFirst('form');

  @override
  TsElement? get input => _findFirst('input');

  @override
  TsElement? get button => _findFirst('button');

  @override
  TsElement? get label => _findFirst('label');

  @override
  TsElement? get selectTag => _findFirst('select');

  @override
  TsElement? get textarea => _findFirst('textarea');

  @override
  TsElement? get section => _findFirst('section');

  @override
  TsElement? get article => _findFirst('article');

  @override
  TsElement? get header => _findFirst('header');

  @override
  TsElement? get footer => _findFirst('footer');

  @override
  TsElement? get nav => _findFirst('nav');

  @override
  TsElement? get main => _findFirst('main');

  @override
  TsElement? get li => _findFirst('li');

  @override
  TsElement? get tr => _findFirst('tr');

  @override
  TsElement? get td => _findFirst('td');

  @override
  TsElement? get th => _findFirst('th');

  @override
  TsElement? get code => _findFirst('code');

  @override
  TsElement? get pre => _findFirst('pre');

  @override
  TsElement? get iframe => _findFirst('iframe');

  // Plural Collection Getters

  @override
  List<TsElement> get links => _findAll('a');

  @override
  List<TsElement> get paragraphs => _findAll('p');

  @override
  List<TsElement> get imgs => _findAll('img');

  @override
  List<TsElement> get divs => _findAll('div');

  @override
  List<TsElement> get spans => _findAll('span');

  @override
  List<TsElement> get buttons => _findAll('button');

  @override
  List<TsElement> get inputs => _findAll('input');

  @override
  List<TsElement> get forms => _findAll('form');

  @override
  List<TsElement> get tables => _findAll('table');

  @override
  List<TsElement> get rows => _findAll('tr');

  @override
  List<TsElement> get cells => _findAll('td, th');

  @override
  List<TsElement> get items => _findAll('li');

  @override
  List<TsElement> get headings => _findAll('h1, h2, h3, h4, h5, h6');
}

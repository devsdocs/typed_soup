# Typed Soup

[![pub package](https://img.shields.io/pub/v/typed_soup.svg)](https://pub.dev/packages/typed_soup)
![tests](https://github.com/devsdocs/typed_soup/actions/workflows/main.yml/badge.svg)
[![codecov](https://codecov.io/gh/devsdocs/typed_soup/branch/master/graph/badge.svg)](https://codecov.io/gh/devsdocs/typed_soup)

Dart native package inspired by Beautiful Soup 4 Python library. Provides easy ways of navigating, searching, and modifying the HTML tree.

This package is a fork of the original [beautiful_soup_dart](https://github.com/mzdm/beautiful_soup) by [mzdm](https://github.com/mzdm).

## Quick Start

```dart
import 'package:typed_soup/typed_soup.dart';

void main() {
  const htmlDoc = '''
  <html><head><title>The Dormouse's story</title></head>
  <body>
    <p class="title"><b>The Dormouse's story</b></p>
    <p class="story">Once upon a time there were three little sisters; and their names were
      <a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
      <a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
      <a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
      and they lived at the bottom of a well.
    </p>
  </body></html>
  ''';

  // 1. Parse HTML document
  final ts = TypedSoup(htmlDoc);

  // 2. Navigate and Search
  print(ts.title?.string); // "The Dormouse's story"
  print(ts.find('p', class_: 'story')?.outerHtml);

  // 3. Modify
  final link1 = ts.find('a', id: 'link1')!;
  link1['class'] = 'active';
  print(link1.outerHtml);
}
```

## Documentation & Code Examples

### Table of Contents

- [Parsing HTML](#parsing-html)
  - [Document and Fragment Parsing](#document-and-fragment-parsing)
  - [Direct Tag Collections and Property Accessors](#direct-tag-collections-and-property-accessors)
  - [Table Data Parsing, Data Attributes, and Ancestor Matching](#table-data-parsing-data-attributes-and-ancestor-matching)
  - [Form Serialization, ownText, List Extensions, and Custom Search](#form-serialization-owntext-list-extensions-and-custom-search)
- [Navigating the Tree](#navigating-the-tree)
  - [Navigating using tag names](#navigating-using-tag-names)
  - [.contents and .children](#contents-and-children)
  - [.descendants and .selfAndDescendants](#descendants-and-selfanddescendants)
  - [.string, .strings, and .strippedStrings](#string-strings-and-strippedstrings)
  - [.parent, .parents, and .selfAndParents](#parent-parents-and-selfandparents)
  - [.nextSibling, .previousSibling, .nextSiblings, .previousSiblings](#nextsibling-previoussibling-nextsiblings-previoussiblings)
  - [.nextElement, .previousElement, .nextElements, .previousElements](#nextelement-previouselement-nextelements-previouselements)
  - [.nextParsed and .previousParsed](#nextparsed-and-previousparsed)
- [Searching the Tree](#searching-the-tree)
  - [find() and findAll()](#find-and-findall)
  - [select() and select_one() CSS Selectors](#select-and-selectone-css-selectors)
  - [findFirstAny()](#findfirstany)
  - [findParents(), findNextSiblings(), findPreviousSiblings()](#findparents-findnextsiblings-findprevioussiblings)
  - [findAllNextElements(), findNextElement(), and findPreviousElement()](#findallnextelements-findnextelement-and-findpreviouselement)
- [Modifying the Tree](#modifying-the-tree)
  - [Modifying tag names and attributes](#modifying-tag-names-and-attributes)
  - [append(), extend(), insert(), and TypedSoup.newTag()](#append-extend-insert-and-typedsoupnewtag)
  - [insertBefore() and insertAfter()](#insertbefore-and-insertafter)
  - [wrap(), wrapWithString(), unwrap(), and replaceWith()](#wrap-wrapwithstring-unwrap-and-replacewith)
  - [clear(), extract(), decompose(), and replaceWithChildren()](#clear-extract-decompose-and-replacewithchildren)
- [Output](#output)
  - [prettify(), text, and getText()](#prettify-text-and-gettext)
  - [Exporting Complete Modified HTML](#exporting-complete-modified-html)

## Parsing HTML

### Document and Fragment Parsing

Parse full HTML documents, partial HTML fragments, or wrap standard DOM elements.

```dart
// Parse a full HTML document
final tsDoc = TypedSoup(htmlDoc);
print(tsDoc.title?.string);
// Output: The Dormouse's story

// Parse an HTML fragment
final tsFrag = TypedSoup.fragment('<div class="box"><span>Fragment Content</span></div>');
print(tsFrag.find('span')?.string);
// Output: Fragment Content

// Or use String extension:
final tsExt = '<div class="box"><span>Fragment Content</span></div>'.parseSoupFragment();
print(tsExt.span?.string);
```

### Direct Tag Collections and Property Accessors

Access plural element getters, attribute properties, and element helpers.

```dart
final ts = htmlDoc.parseSoup();

// Plural tag collection getters
print(ts.links.map((e) => e.href).toList());
// Output: [http://example.com/elsie, http://example.com/lacie, http://example.com/tillie]

print(ts.paragraphs.length); // 3

// Property accessors for common attributes
final link1 = ts.links.first;
print(link1.href); // http://example.com/elsie
print(link1.trimmedText); // Elsie

// Quick child existence check
print(ts.body!.hasChild('p.story')); // true
```

### Table Data Parsing, Data Attributes, and Ancestor Matching

Convert HTML tables directly to List<Map<String, String>>, access HTML5 data-* attributes, and find closest matching ancestors.

```dart
// 1. Table Parsing to JSON/Maps
final tableTs = """
<table>
  <tr><th>Name</th><th>Role</th></tr>
  <tr><td>Alice</td><td>Admin</td></tr>
</table>
""".parseSoup();

List<Map<String, String>> tableData = tableTs.table!.toTableData();
print(tableData);
// Output: [{'Name': 'Alice', 'Role': 'Admin'}]

// 2. HTML5 Data Attributes
final userDiv = '<div data-user-id="42" data-role="editor"></div>'.parseSoupFragment().div!;
print(userDiv.dataAttr('user-id')); // 42
print(userDiv.dataAttrs); // {'user-id': '42', 'role': 'editor'}

// 3. Nearest Ancestor Matching (.closest)
final link = htmlDoc.parseSoup().find('a', id: 'link1')!;
print(link.closest('p.story')?.className); // story

// 4. Text Line Cleaning (.strippedLines)
final multiline = "<div>\n  Line 1  \n\n  Line 2  \n</div>".parseSoupFragment().div!;
print(multiline.strippedLines); // [Line 1, Line 2]
```

### Form Serialization, ownText, List Extensions, and Custom Search

Extract form data maps, retrieve direct node ownText, use collection extensions, and search with custom predicates.

```dart
// 1. Form Data Serialization
final formTs = """
<form action="/login">
  <input name="user" value="alice" />
  <input name="pass" value="secret" />
</form>
""".parseSoup();
print(formTs.form!.toFormData()); // {'user': 'alice', 'pass': 'secret'}

// 2. Direct ownText (excluding nested tags)
final card = '<div>Welcome <span>User</span>!</div>'.parseSoupFragment().div!;
print(card.text); // Welcome User!
print(card.ownTextTrimmed); // Welcome !

// 3. List Collection Extensions (.hrefs, .trimmedTexts, .withClass)
final links = htmlDoc.parseSoup().links;
print(links.hrefs); // [http://example.com/elsie, http://example.com/lacie, http://example.com/tillie]

// 4. Custom Predicate Search (.findWhere / .findAllWhere)
final match = htmlDoc.parseSoup().findWhere((e) => e.href?.contains('lacie') ?? false);
print(match?.string); // Lacie
```

## Navigating the Tree

### Navigating using tag names

Access child tags directly as properties on `TypedSoup` or `TsElement`.

```dart
final ts = TypedSoup(htmlDoc);

// Navigate directly via tag properties
print(ts.head?.title?.string);
// Output: The Dormouse's story

print(ts.body?.p?.b?.string);
// Output: The Dormouse's story

print(ts.find('p')?.outerHtml);
// Output: <p class="title"><b>The Dormouse's story</b></p>
```

### .contents and .children

Get immediate child elements of a tag as a list.

```dart
final ts = TypedSoup(htmlDoc);
final head = ts.head!;

// .children and .contents return direct child TsElements
print(head.children.map((e) => e.name).toList());
// Output: [title]

print(head.contents.length);
// Output: 1
```

### .descendants and .selfAndDescendants

Recursively iterate through all descendant tags below an element.

```dart
final ts = TypedSoup(htmlDoc);
final body = ts.body!;

// All nested elements under <body>
print(body.descendants.map((e) => e.name).toList());
// Output: [p, b, p, a, a, a, p]

// Includes current element plus descendants
print(body.p!.selfAndDescendants.map((e) => e.name).toList());
// Output: [p, b]
```

### .string, .strings, and .strippedStrings

Retrieve text contents of elements and their descendants.

```dart
final ts = TypedSoup(htmlDoc);
final link = ts.find('a', id: 'link1')!;

print(link.string);
// Output: Elsie

// Iterate all non-empty stripped strings
final storyP = ts.find('p', class_: 'story')!;
print(storyP.strippedStrings.take(2).toList());
// Output: [Once upon a time there were three little sisters; and their names were, Elsie]
```

### .parent, .parents, and .selfAndParents

Navigate upward to ancestor elements.

```dart
final ts = TypedSoup(htmlDoc);
final link = ts.find('a', id: 'link1')!;

print(link.parent?.name);
// Output: p

print(link.parents.map((e) => e.name).toList());
// Output: [p, body, html]

print(link.selfAndParents.map((e) => e.name).toList());
// Output: [a, p, body, html]
```

### .nextSibling, .previousSibling, .nextSiblings, .previousSiblings

Navigate sideways between adjacent sibling elements.

```dart
final ts = TypedSoup(htmlDoc);
final link1 = ts.find('a', id: 'link1')!;

print(link1.nextSibling?.id);
// Output: link2

print(link1.nextSiblings.map((e) => e.id).toList());
// Output: [link2, link3]

final link2 = ts.find('a', id: 'link2')!;
print(link2.previousSibling?.id);
// Output: link1

print(link1.selfAndNextSiblings.map((e) => e.id).toList());
// Output: [link1, link2, link3]
```

### .nextElement, .previousElement, .nextElements, .previousElements

Traverse elements in parse tree order regardless of hierarchy.

```dart
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

print(titleP.nextElement?.name);
// Output: b

print(titleP.nextElements.map((e) => e.name).take(3).toList());
// Output: [b, p, a]
```

### .nextParsed and .previousParsed

Access the next/previous parsed node in document order (including text, comments, and elements).

```dart
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

// .nextParsed returns the raw DOM Node
final node = titleP.nextParsed;
print(node?.data);
```

## Searching the Tree

### find() and findAll()

Search by tag name, attributes, classes, IDs, regular expressions, strings, or limit results.

```dart
final ts = TypedSoup(htmlDoc);

// Find single element by tag and class
final titleP = ts.find('p', class_: 'title');
print(titleP?.outerHtml);
// Output: <p class="title"><b>The Dormouse's story</b></p>

// Find all elements matching criteria with limit
final links = ts.findAll('a', class_: 'sister', limit: 2);
print(links.map((e) => e.id).toList());
// Output: [link1, link2]

// Find elements with attribute presence (boolean true)
final hasHref = ts.findAll('a', attrs: {'href': true});
print(hasHref.length);
// Output: 2

// Find using regex for tag names
final bTags = ts.findAll('*', regex: r'^b');
print(bTags.map((e) => e.name).toList());
// Output: [body, b]

// Find using string matching
final storyText = ts.find('p', string: r'^Once upon');
print(storyText?.className);
// Output: story
```

### select() and select_one() CSS Selectors

Query elements using standard CSS selectors, pseudo-classes, and hierarchy.

```dart
final ts = TypedSoup(htmlDoc);

// Select multiple elements with descendant CSS selector
final links = ts.select('p.story > a.sister');
print(links.map((e) => e.id).toList());
// Output: [link1, link2, link3]

// Select single element with ID selector
final link1 = ts.select_one('#link1');
print(link1?.string);
// Output: Elsie

// Pseudo-class selector :first-child
final firstP = ts.select_one('p:first-child');
print(firstP?.className);
// Output: title
```

### findFirstAny()

Find the top-most (first) element in the parse tree.

```dart
final ts = TypedSoup(htmlDoc);

final first = ts.findFirstAny();
print(first?.name);
// Output: html
```

### findParents(), findNextSiblings(), findPreviousSiblings()

Perform targeted searches relative to a specific element.

```dart
final ts = TypedSoup(htmlDoc);
final link1 = ts.find('a', id: 'link1')!;

// Find parent element matching criteria
final parentStory = link1.findParent('p', class_: 'story');
print(parentStory?.className);
// Output: story

// Find subsequent sibling links
final nextLinks = link1.findNextSiblings('a');
print(nextLinks.map((e) => e.id).toList());
// Output: [link2, link3]

// Find previous sibling links
final link3 = ts.find('a', id: 'link3')!;
final prevLinks = link3.findPreviousSiblings('a');
print(prevLinks.map((e) => e.id).toList());
// Output: [link2, link1]
```

### findAllNextElements(), findNextElement(), and findPreviousElement()

Find elements forward or backward in parse tree order.

```dart
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

// Find next element of specific tag
final nextA = titleP.findNextElement('a');
print(nextA?.id);
// Output: link1

// Find all subsequent elements of specific tag
final allNextA = titleP.findAllNextElements('a');
print(allNextA.map((e) => e.id).toList());
// Output: [link1, link2, link3]
```

## Modifying the Tree

### Modifying tag names and attributes

Update element names, attributes, class names, IDs, and text contents.

```dart
final ts = TypedSoup(htmlDoc);
final link = ts.find('a', id: 'link1')!;

// Change tag name
link.name = 'span';

// Modify attributes and properties
link['class'] = 'active';
link.setAttr('data-test', '123');
link.string = 'Elsie (Modified)';

print(link.hasAttr('data-test')); // true
print(link.getAttrValue('data-test')); // 123

// Remove an attribute
link.removeAttr('data-test');
print(link.hasAttr('data-test')); // false
```

### append(), extend(), insert(), and TypedSoup.newTag()

Construct and insert new tags or lists of tags into the tree.

```dart
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

// Create new element
final badge = TypedSoup.newTag('span', attrs: {'class': 'badge'}, string: ' New!');

// Append to title paragraph
titleP.append(badge);

print(titleP.outerHtml);
// Output: <p class="title"><b>The Dormouse's story</b><span class="badge"> New!</span></p>

// Extend with multiple tags
final tag1 = TypedSoup.newTag('b', string: ' [Tag1]');
final tag2 = TypedSoup.newTag('b', string: ' [Tag2]');
titleP.extend([tag1, tag2]);

// Insert at specific index
final icon = TypedSoup.newTag('i', string: '★ ');
titleP.insert(0, icon);
```

### insertBefore() and insertAfter()

Insert new elements adjacent to a reference element.

```dart
final ts = TypedSoup(htmlDoc);
final link2 = ts.find('a', id: 'link2')!;

final labelBefore = TypedSoup.newTag('b', string: '[BEFORE] ');
link2.insertBefore(labelBefore);

final labelAfter = TypedSoup.newTag('b', string: ' [AFTER]');
link2.insertAfter(labelAfter);

print(link2.previousSibling?.string);
// Output: [BEFORE]
```

### wrap(), wrapWithString(), unwrap(), and replaceWith()

Wrap elements with parent tags, unwrap them, or replace elements.

```dart
final ts = TypedSoup(htmlDoc);
final b = ts.find('b')!;

// Wrap with newly created element
b.wrap(TypedSoup.newTag('div', attrs: {'class': 'header-wrapper'}));
print(b.parent?.className);
// Output: header-wrapper

// Unwrap element
b.unwrap();

// Wrap with wrapper element and string
b.wrapWithString(TypedSoup.newTag('div', attrs: {'class': 'box'}), 'Prefix Text: ');

// Replace element
final replacement = TypedSoup.newTag('em', string: 'Replaced Title');
ts.find('p', class_: 'title')?.replaceWith(replacement);
```

### clear(), extract(), decompose(), and replaceWithChildren()

Remove content or prune elements from the parse tree.

```dart
final ts = TypedSoup(htmlDoc);

// Clear inner content of element
final titleP = ts.find('p', class_: 'title')!;
titleP.clear();
print(titleP.children.length); // 0

// Extract tag from tree
final link3 = ts.find('a', id: 'link3')!;
final extracted = link3.extract();
print(extracted.id); // link3

// Decompose tag
final link2 = ts.find('a', id: 'link2')!;
link2.decompose();
print(link2.decomposed); // true
```

## Output

### prettify(), text, and getText()

Format HTML output or extract formatted text strings.

```dart
final ts = TypedSoup(htmlDoc);

// Formatted HTML output
print(ts.prettify());

// Plain text content of entire document
print(ts.text);

// Custom formatted text extraction
final storyP = ts.find('p', class_: 'story')!;
print(storyP.getText(separator: ' | ', strip: true));
```

### Exporting Complete Modified HTML

Retrieve the complete modified HTML of the document after making changes in place.

```dart
final ts = TypedSoup(htmlDoc);

// Mutate tree in place
ts.find('a', id: 'link1')!['class'] = 'active';
ts.find('p', class_: 'title')?.append(TypedSoup.newTag('span', string: ' [Updated]'));

// Method 1: Convert entire document to outer HTML string
String modifiedHtml = ts.toString(); // or ts.doc.outerHtml
print(modifiedHtml);

// Method 2: Prettified HTML output of modified document
String prettyHtml = ts.prettify();
print(prettyHtml);
```

## Additional Information

Other methods from the `Element` class in the [`html package`](https://pub.dev/packages/html) can be accessed directly via `TsElement.element`.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/devsdocs/typed_soup/issues) or feel free to raise a PR.


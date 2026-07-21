import 'dart:io';
import 'package:typed_soup/typed_soup.dart';

const String htmlDoc = '''
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>
<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
<p class="story">...</p>
</body></html>
''';

class ExampleItem {
  final String title;
  final String description;
  final String code;
  final void Function(TypedSoup ts) verify;

  ExampleItem({
    required this.title,
    required this.description,
    required this.code,
    required this.verify,
  });
}

class ExampleSection {
  final String category;
  final List<ExampleItem> items;

  ExampleSection({required this.category, required this.items});
}

void main() {
  print('Verifying all API examples with TypedSoup...');

  final sections = [
    ExampleSection(
      category: 'Parsing HTML',
      items: [
        ExampleItem(
          title: 'Document and Fragment Parsing',
          description:
              'Parse full HTML documents, partial HTML fragments, or wrap standard DOM elements.',
          code: '''
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
''',
          verify: (ts) {
            final tsDoc = TypedSoup(htmlDoc);
            assert(tsDoc.title?.string == "The Dormouse's story");
            final tsFrag = TypedSoup.fragment(
              '<div class="box"><span>Fragment Content</span></div>',
            );
            assert(tsFrag.find('span')?.string == 'Fragment Content');
            final tsExt = '<div class="box"><span>Fragment Content</span></div>'
                .parseSoupFragment();
            assert(tsExt.span?.string == 'Fragment Content');
          },
        ),
        ExampleItem(
          title: 'Direct Tag Collections and Property Accessors',
          description:
              'Access plural element getters, attribute properties, and element helpers.',
          code: '''
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
''',
          verify: (ts) {
            final tsDoc = htmlDoc.parseSoup();
            assert(tsDoc.links.length == 3);
            assert(tsDoc.paragraphs.length == 3);
            final link1 = tsDoc.links.first;
            assert(link1.href == 'http://example.com/elsie');
            assert(link1.trimmedText == 'Elsie');
            assert(tsDoc.body!.hasChild('p.story'));
          },
        ),
        ExampleItem(
          title: 'Table Data Parsing, Data Attributes, and Ancestor Matching',
          description:
              'Convert HTML tables directly to List<Map<String, String>>, access HTML5 data-* attributes, and find closest matching ancestors.',
          code: '''
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
final multiline = "<div>\\n  Line 1  \\n\\n  Line 2  \\n</div>".parseSoupFragment().div!;
print(multiline.strippedLines); // [Line 1, Line 2]
''',
          verify: (ts) {
            final tableTs =
                """
<table>
  <tr><th>Name</th><th>Role</th></tr>
  <tr><td>Alice</td><td>Admin</td></tr>
</table>
"""
                    .parseSoup();
            final tableData = tableTs.table!.toTableData();
            assert(tableData.length == 1);
            assert(tableData[0]['Name'] == 'Alice');

            final userDiv = '<div data-user-id="42" data-role="editor"></div>'
                .parseSoupFragment()
                .div!;
            assert(userDiv.dataAttr('user-id') == '42');
            assert(userDiv.dataAttrs['role'] == 'editor');

            final link = htmlDoc.parseSoup().find('a', id: 'link1')!;
            assert(link.closest('p.story')?.className == 'story');

            final multiline = "<div>\n  Line 1  \n\n  Line 2  \n</div>"
                .parseSoupFragment()
                .div!;
            assert(multiline.strippedLines.length == 2);
          },
        ),
        ExampleItem(
          title:
              'Form Serialization, ownText, List Extensions, and Custom Search',
          description:
              'Extract form data maps, retrieve direct node ownText, use collection extensions, and search with custom predicates.',
          code: '''
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
''',
          verify: (ts) {
            final formTs =
                """
<form action="/login">
  <input name="user" value="alice" />
  <input name="pass" value="secret" />
</form>
"""
                    .parseSoup();
            assert(formTs.form!.toFormData()['user'] == 'alice');

            final card = '<div>Welcome <span>User</span>!</div>'
                .parseSoupFragment()
                .div!;
            assert(card.ownTextTrimmed == 'Welcome !');

            final links = htmlDoc.parseSoup().links;
            assert(links.hrefs.length == 3);

            final match = htmlDoc.parseSoup().findWhere(
              (e) => e.href?.contains('lacie') ?? false,
            );
            assert(match?.string == 'Lacie');
          },
        ),
      ],
    ),
    ExampleSection(
      category: 'Navigating the Tree',
      items: [
        ExampleItem(
          title: 'Navigating using tag names',
          description:
              'Access child tags directly as properties on `TypedSoup` or `TsElement`.',
          code: '''
final ts = TypedSoup(htmlDoc);

// Navigate directly via tag properties
print(ts.head?.title?.string);
// Output: The Dormouse's story

print(ts.body?.p?.b?.string);
// Output: The Dormouse's story

print(ts.find('p')?.outerHtml);
// Output: <p class="title"><b>The Dormouse's story</b></p>
''',
          verify: (ts) {
            assert(ts.head?.title?.string == "The Dormouse's story");
            assert(ts.body?.p?.b?.string == "The Dormouse's story");
            assert(
              ts.find('p')?.outerHtml ==
                  '<p class="title"><b>The Dormouse\'s story</b></p>',
            );
          },
        ),
        ExampleItem(
          title: '.contents and .children',
          description: 'Get immediate child elements of a tag as a list.',
          code: '''
final ts = TypedSoup(htmlDoc);
final head = ts.head!;

// .children and .contents return direct child TsElements
print(head.children.map((e) => e.name).toList());
// Output: [title]

print(head.contents.length);
// Output: 1
''',
          verify: (ts) {
            final head = ts.head!;
            assert(head.children.map((e) => e.name).join(',') == 'title');
            assert(head.contents.length == 1);
          },
        ),
        ExampleItem(
          title: '.descendants and .selfAndDescendants',
          description:
              'Recursively iterate through all descendant tags below an element.',
          code: '''
final ts = TypedSoup(htmlDoc);
final body = ts.body!;

// All nested elements under <body>
print(body.descendants.map((e) => e.name).toList());
// Output: [p, b, p, a, a, a, p]

// Includes current element plus descendants
print(body.p!.selfAndDescendants.map((e) => e.name).toList());
// Output: [p, b]
''',
          verify: (ts) {
            final body = ts.body!;
            assert(body.descendants.length == 7);
            assert(body.p!.selfAndDescendants.length == 2);
          },
        ),
        ExampleItem(
          title: '.string, .strings, and .strippedStrings',
          description:
              'Retrieve text contents of elements and their descendants.',
          code: '''
final ts = TypedSoup(htmlDoc);
final link = ts.find('a', id: 'link1')!;

print(link.string);
// Output: Elsie

// Iterate all non-empty stripped strings
final storyP = ts.find('p', class_: 'story')!;
print(storyP.strippedStrings.take(2).toList());
// Output: [Once upon a time there were three little sisters; and their names were, Elsie]
''',
          verify: (ts) {
            final link = ts.find('a', id: 'link1')!;
            assert(link.string == 'Elsie');
            assert(ts.find('p', class_: 'story')!.strippedStrings.isNotEmpty);
          },
        ),
        ExampleItem(
          title: '.parent, .parents, and .selfAndParents',
          description: 'Navigate upward to ancestor elements.',
          code: '''
final ts = TypedSoup(htmlDoc);
final link = ts.find('a', id: 'link1')!;

print(link.parent?.name);
// Output: p

print(link.parents.map((e) => e.name).toList());
// Output: [p, body, html]

print(link.selfAndParents.map((e) => e.name).toList());
// Output: [a, p, body, html]
''',
          verify: (ts) {
            final link = ts.find('a', id: 'link1')!;
            assert(link.parent?.name == 'p');
            assert(link.parents.map((e) => e.name).contains('body'));
            assert(link.selfAndParents.first.name == 'a');
          },
        ),
        ExampleItem(
          title:
              '.nextSibling, .previousSibling, .nextSiblings, .previousSiblings',
          description: 'Navigate sideways between adjacent sibling elements.',
          code: '''
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
''',
          verify: (ts) {
            final link1 = ts.find('a', id: 'link1')!;
            assert(link1.nextSibling?.id == 'link2');
            assert(link1.nextSiblings.length == 2);
            final link2 = ts.find('a', id: 'link2')!;
            assert(link2.previousSibling?.id == 'link1');
            assert(link1.selfAndNextSiblings.length == 3);
          },
        ),
        ExampleItem(
          title:
              '.nextElement, .previousElement, .nextElements, .previousElements',
          description:
              'Traverse elements in parse tree order regardless of hierarchy.',
          code: '''
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

print(titleP.nextElement?.name);
// Output: b

print(titleP.nextElements.map((e) => e.name).take(3).toList());
// Output: [b, p, a]
''',
          verify: (ts) {
            final titleP = ts.find('p', class_: 'title')!;
            assert(titleP.nextElement?.name == 'b');
            assert(titleP.nextElements.isNotEmpty);
          },
        ),
        ExampleItem(
          title: '.nextParsed and .previousParsed',
          description:
              'Access the next/previous parsed node in document order (including text, comments, and elements).',
          code: '''
final ts = TypedSoup(htmlDoc);
final titleP = ts.find('p', class_: 'title')!;

// .nextParsed returns the raw DOM Node
final node = titleP.nextParsed;
print(node?.data);
''',
          verify: (ts) {
            final titleP = ts.find('p', class_: 'title')!;
            assert(titleP.nextParsed != null);
          },
        ),
      ],
    ),
    ExampleSection(
      category: 'Searching the Tree',
      items: [
        ExampleItem(
          title: 'find() and findAll()',
          description:
              'Search by tag name, attributes, classes, IDs, regular expressions, strings, or limit results.',
          code: '''
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
''',
          verify: (ts) {
            assert(ts.find('p', class_: 'title') != null);
            assert(ts.findAll('a', class_: 'sister', limit: 2).length == 2);
            assert(ts.findAll('a', attrs: {'href': true}).length == 2);
            assert(ts.findAll('*', regex: r'^b').length >= 2);
            assert(ts.find('p', string: r'^Once upon') != null);
          },
        ),
        ExampleItem(
          title: 'select() and select_one() CSS Selectors',
          description:
              'Query elements using standard CSS selectors, pseudo-classes, and hierarchy.',
          code: '''
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
''',
          verify: (ts) {
            assert(ts.select('p.story > a.sister').length == 3);
            assert(ts.select_one('#link1')?.string == 'Elsie');
            assert(ts.select_one('p:first-child')?.className == 'title');
          },
        ),
        ExampleItem(
          title: 'findFirstAny()',
          description: 'Find the top-most (first) element in the parse tree.',
          code: '''
final ts = TypedSoup(htmlDoc);

final first = ts.findFirstAny();
print(first?.name);
// Output: html
''',
          verify: (ts) {
            assert(ts.findFirstAny()?.name == 'html');
          },
        ),
        ExampleItem(
          title: 'findParents(), findNextSiblings(), findPreviousSiblings()',
          description:
              'Perform targeted searches relative to a specific element.',
          code: '''
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
''',
          verify: (ts) {
            final link1 = ts.find('a', id: 'link1')!;
            assert(
              link1.findParent('p', class_: 'story')?.className == 'story',
            );
            assert(link1.findNextSiblings('a').length == 2);
            final link3 = ts.find('a', id: 'link3')!;
            assert(link3.findPreviousSiblings('a').length == 2);
          },
        ),
        ExampleItem(
          title:
              'findAllNextElements(), findNextElement(), and findPreviousElement()',
          description: 'Find elements forward or backward in parse tree order.',
          code: '''
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
''',
          verify: (ts) {
            final titleP = ts.find('p', class_: 'title')!;
            assert(titleP.findNextElement('a')?.id == 'link1');
            assert(titleP.findAllNextElements('a').length == 3);
          },
        ),
      ],
    ),
    ExampleSection(
      category: 'Modifying the Tree',
      items: [
        ExampleItem(
          title: 'Modifying tag names and attributes',
          description:
              'Update element names, attributes, class names, IDs, and text contents.',
          code: '''
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
''',
          verify: (ts) {
            final link = ts.find('a', id: 'link1')!;
            link.name = 'span';
            link['class'] = 'active';
            link.setAttr('data-test', '123');
            link.string = 'Elsie (Modified)';
            assert(link.name == 'span');
            assert(link.className == 'active');
            assert(link.hasAttr('data-test'));
            assert(link.getAttrValue('data-test') == '123');
            link.removeAttr('data-test');
            assert(!link.hasAttr('data-test'));
          },
        ),
        ExampleItem(
          title: 'append(), extend(), insert(), and TypedSoup.newTag()',
          description:
              'Construct and insert new tags or lists of tags into the tree.',
          code: '''
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
''',
          verify: (ts) {
            final titleP = ts.find('p', class_: 'title')!;
            final badge = TypedSoup.newTag(
              'span',
              attrs: {'class': 'badge'},
              string: ' New!',
            );
            titleP.append(badge);
            assert(
              titleP.outerHtml.contains('<span class="badge"> New!</span>'),
            );
            final tag1 = TypedSoup.newTag('b', string: ' [Tag1]');
            final tag2 = TypedSoup.newTag('b', string: ' [Tag2]');
            titleP.extend([tag1, tag2]);
            assert(titleP.outerHtml.contains('[Tag2]'));
            final icon = TypedSoup.newTag('i', string: '★ ');
            titleP.insert(0, icon);
            assert(titleP.children.first.name == 'i');
          },
        ),
        ExampleItem(
          title: 'insertBefore() and insertAfter()',
          description: 'Insert new elements adjacent to a reference element.',
          code: '''
final ts = TypedSoup(htmlDoc);
final link2 = ts.find('a', id: 'link2')!;

final labelBefore = TypedSoup.newTag('b', string: '[BEFORE] ');
link2.insertBefore(labelBefore);

final labelAfter = TypedSoup.newTag('b', string: ' [AFTER]');
link2.insertAfter(labelAfter);

print(link2.previousSibling?.string);
// Output: [BEFORE] 
''',
          verify: (ts) {
            final link2 = ts.find('a', id: 'link2')!;
            final labelBefore = TypedSoup.newTag('b', string: '[BEFORE] ');
            link2.insertBefore(labelBefore);
            final labelAfter = TypedSoup.newTag('b', string: ' [AFTER]');
            link2.insertAfter(labelAfter);
            assert(link2.previousSibling?.string == '[BEFORE] ');
            assert(link2.nextSibling?.string == ' [AFTER]');
          },
        ),
        ExampleItem(
          title: 'wrap(), wrapWithString(), unwrap(), and replaceWith()',
          description:
              'Wrap elements with parent tags, unwrap them, or replace elements.',
          code: '''
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
''',
          verify: (ts) {
            final b = ts.find('b')!;
            b.wrap(TypedSoup.newTag('div', attrs: {'class': 'header-wrapper'}));
            assert(b.parent?.className == 'header-wrapper');
            b.unwrap();
            assert(b.parent?.name == 'p');
            b.wrapWithString(
              TypedSoup.newTag('div', attrs: {'class': 'box'}),
              'Prefix Text: ',
            );
            assert(b.parent?.className == 'box');
          },
        ),
        ExampleItem(
          title: 'clear(), extract(), decompose(), and replaceWithChildren()',
          description: 'Remove content or prune elements from the parse tree.',
          code: '''
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
''',
          verify: (ts) {
            final titleP = ts.find('p', class_: 'title')!;
            titleP.clear();
            assert(titleP.children.isEmpty);
            final link3 = ts.find('a', id: 'link3')!;
            final extracted = link3.extract();
            assert(extracted.id == 'link3');
            final link2 = ts.find('a', id: 'link2')!;
            link2.decompose();
            assert(link2.decomposed);
          },
        ),
      ],
    ),
    ExampleSection(
      category: 'Output',
      items: [
        ExampleItem(
          title: 'prettify(), text, and getText()',
          description: 'Format HTML output or extract formatted text strings.',
          code: '''
final ts = TypedSoup(htmlDoc);

// Formatted HTML output
print(ts.prettify());

// Plain text content of entire document
print(ts.text);

// Custom formatted text extraction
final storyP = ts.find('p', class_: 'story')!;
print(storyP.getText(separator: ' | ', strip: true));
''',
          verify: (ts) {
            assert(ts.prettify().contains('<head>'));
            assert(ts.text.contains("The Dormouse's story"));
            final storyP = ts.find('p', class_: 'story')!;
            assert(
              storyP.getText(separator: ' | ', strip: true).contains('Elsie'),
            );
          },
        ),
        ExampleItem(
          title: 'Exporting Complete Modified HTML',
          description:
              'Retrieve the complete modified HTML of the document after making changes in place.',
          code: '''
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
''',
          verify: (ts) {
            ts.find('a', id: 'link1')!['class'] = 'active';
            assert(ts.toString().contains('class="active"'));
            assert(ts.prettify().contains('class="active"'));
          },
        ),
      ],
    ),
  ];

  int total = 0;
  for (final section in sections) {
    for (final item in section.items) {
      try {
        final ts = TypedSoup(htmlDoc);
        item.verify(ts);
        total++;
        print('  ✓ Verified: ${section.category} -> ${item.title}');
      } catch (e, st) {
        print('  ✗ Failed: ${section.category} -> ${item.title}: $e\n$st');
        exit(1);
      }
    }
  }

  print('\nAll $total API examples verified successfully against TypedSoup!');

  // Generate test file
  writeTestFile(sections);

  // Generate README.md
  writeReadme(sections);
}

void writeTestFile(List<ExampleSection> sections) {
  final file = File('test/readme_examples_test.dart');
  final buffer = StringBuffer();
  buffer.writeln(
    "// AUTOMATICALLY GENERATED BY tool/generate_examples.dart - DO NOT EDIT",
  );
  buffer.writeln("import 'package:test/test.dart';");
  buffer.writeln("import 'package:typed_soup/typed_soup.dart';");
  buffer.writeln();
  buffer.writeln("const String htmlDoc = '''$htmlDoc''';");
  buffer.writeln();
  buffer.writeln("void main() {");
  buffer.writeln("  group('README Verified Examples', () {");

  for (final section in sections) {
    buffer.writeln("    group('${section.category}', () {");
    for (final item in section.items) {
      final safeTitle = item.title.replaceAll("'", "\\'");
      buffer.writeln("      test('$safeTitle', () {");
      final lines = item.code.trim().split('\n');
      for (final line in lines) {
        buffer.writeln("        $line");
      }
      buffer.writeln("      });");
    }
    buffer.writeln("    });");
  }

  buffer.writeln("  });");
  buffer.writeln("}");

  file.writeAsStringSync(buffer.toString());
  print('Generated test file: test/readme_examples_test.dart');
}

void writeReadme(List<ExampleSection> sections) {
  final file = File('README.md');
  final buffer = StringBuffer();

  buffer.writeln('''# Typed Soup

[![pub package](https://img.shields.io/pub/v/typed_soup.svg)](https://pub.dev/packages/typed_soup)
![tests](https://github.com/devsdocs/typed_soup/actions/workflows/main.yml/badge.svg)
[![codecov](https://codecov.io/gh/devsdocs/typed_soup/branch/master/graph/badge.svg)](https://codecov.io/gh/devsdocs/typed_soup)

Dart native package inspired by Beautiful Soup 4 Python library. Provides easy ways of navigating, searching, and modifying the HTML tree.

This package is a fork of the original [beautiful_soup_dart](https://github.com/mzdm/beautiful_soup) by [mzdm](https://github.com/mzdm).

## Quick Start

```dart
import 'package:typed_soup/typed_soup.dart';

void main() {
  const htmlDoc = \'\'\'
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
  \'\'\';

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
''');

  // Table of contents pointing to internal headings
  buffer.writeln('### Table of Contents\n');
  for (final section in sections) {
    final catAnchor = section.category.toLowerCase().replaceAll(' ', '-');
    buffer.writeln('- [${section.category}](#$catAnchor)');
    for (final item in section.items) {
      final itemAnchor = item.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
      buffer.writeln('  - [${item.title}](#$itemAnchor)');
    }
  }
  buffer.writeln();

  // Full sections with executable code snippets
  for (final section in sections) {
    buffer.writeln('## ${section.category}\n');
    for (final item in section.items) {
      buffer.writeln('### ${item.title}\n');
      buffer.writeln('${item.description}\n');
      buffer.writeln('```dart');
      buffer.writeln(item.code.trim());
      buffer.writeln('```\n');
    }
  }

  buffer.writeln('''## Additional Information

Other methods from the `Element` class in the [`html package`](https://pub.dev/packages/html) can be accessed directly via `TsElement.element`.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/devsdocs/typed_soup/issues) or feel free to raise a PR.
''');

  file.writeAsStringSync(buffer.toString());
  print('Updated README.md with working examples!');
}

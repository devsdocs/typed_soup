// ignore_for_file: constant_identifier_names

import 'package:typed_soup/typed_soup.dart';

const html_doc = '''
<html>
   <head>
      <title>The Dormouse's story</title>
   </head>
   <body>
      <p class="title"><b>The Dormouse's story</b></p>
      <p class="story">Once upon a time there were three little sisters; and their names were
         <a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
         <a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
         <a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
         and they lived at the bottom of a well.
      </p>
      <p class="story">...</p>
   </body>
</html>
''';

void main() {
  print('--- 1. Parsing HTML ---');
  final ts = TypedSoup(html_doc);
  final tsFrag = TypedSoup.fragment(
    '<div><span class="note">Fragment</span></div>',
  );
  print('Title from document: ${ts.title?.string}');
  print('Span from fragment: ${tsFrag.find('span')?.string}');

  print('\n--- 2. Navigating the Tree ---');
  print('Direct tag navigation: ${ts.body?.p?.b?.string}');
  print('Parent tag: ${ts.find('a', id: 'link1')?.parent?.name}');
  print('Next sibling: ${ts.find('a', id: 'link1')?.nextSibling?.id}');
  print('Children tag names: ${ts.head?.children.map((e) => e.name).toList()}');

  print('\n--- 3. Searching the Tree ---');
  // Find single element
  final titleP = ts.find('p', class_: 'title');
  print('First title paragraph: ${titleP?.outerHtml}');

  // Find all matching elements
  final sisterLinks = ts.findAll('a', class_: 'sister');
  print('Sister link IDs: ${sisterLinks.map((e) => e.id).toList()}');

  // CSS Selectors
  final firstLink = ts.select_one('p.story > a#link1');
  print('CSS selector match: ${firstLink?.string}');

  print('\n--- 4. Modifying the Tree ---');
  final link1 = ts.find('a', id: 'link1')!;

  // Modify attributes and contents (mutates tree in-place)
  link1['class'] = 'sister active';
  link1.setAttr('data-status', 'verified');
  link1.string = 'Elsie (Updated)';
  print('Modified element: ${link1.outerHtml}');

  // Create and append a new element
  final badge = TypedSoup.newTag(
    'span',
    attrs: {'class': 'badge'},
    string: ' [New]',
  );
  titleP?.append(badge);
  print('Appended element: ${titleP?.outerHtml}');

  print('\n--- 5. Getting Complete Modified HTML ---');
  // All modifications mutate the underlying tree in place.
  // To get the complete modified HTML string:

  // Method 1: ts.toString() or ts.outerHtml (gives full HTML string)
  print('--- Full Modified HTML (toString) ---');
  print(ts.toString());

  // Method 2: ts.prettify() (gives formatted full HTML string)
  print('\n--- Prettified Modified HTML (prettify) ---');
  print(ts.prettify());
}

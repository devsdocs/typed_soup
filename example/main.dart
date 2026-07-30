// ignore_for_file: constant_identifier_names

import 'package:typed_soup/typed_soup.dart';

const html_doc = '''
<html>
   <head>
      <title>The Dormouse's story</title>
   </head>
   <body>
      <p class="title"><b>The Dormouse's story</b></p>
      
      <!-- Section: Story Links -->
      <p class="story">Once upon a time there were three little sisters; and their names were
         <a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
         <a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
         <a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
         and they lived at the bottom of a well.
      </p>
      
      <!-- Section: Product Data -->
      <div class="product">
        <h1 id="product_title">Awesome Shirt</h1>
        <span class="price">\$19.99</span>
        <img src="shirt.png" class="preview" />
      </div>

      <!-- Section: User Post with Malicious Script -->
      <div id="post">
        <script>alert("XSS")</script>
        <p><b>Bold Review</b></p>
      </div>

   </body>
</html>
''';

void main() {
  print('--- 1. Parsing HTML ---');
  final ts = html_doc.parseSoup();
  print('Title from document: ${ts.title?.string}');

  print('\n--- 2. Navigating the Tree ---');
  print('Direct tag navigation: ${ts.body?.p?.b?.string}');
  print('Parent tag: ${ts.find('a', id: 'link1')?.parent?.name}');
  print('Next sibling: ${ts.find('a', id: 'link1')?.nextSibling?.id}');

  print('\n--- 3. Searching the Tree ---');
  final titleP = ts.find('p', class_: 'title');
  print('First title paragraph: ${titleP?.outerHtml}');
  print('Sister link URLs: ${ts.links.map((e) => e.href).toList()}');

  // CSS Selectors
  final firstLink = ts.select_one('p.story > a#link1');
  print('CSS selector match: ${firstLink?.string}');

  print('\n--- 4. Modifying the Tree ---');
  final link1 = ts.find('a', id: 'link1')!;
  link1.href = 'http://example.com/elsie-updated';
  link1['class'] = 'sister active';
  link1.string = 'Elsie (Updated)';
  print('Modified element: ${link1.outerHtml}');

  print('\n--- 5. Getting Complete Modified HTML ---');
  // All modifications mutate the underlying tree in place.
  // To get the complete modified HTML string:

  // Method 1: ts.toString() or ts.outerHtml (gives full HTML string)
  print('--- Full Modified HTML (toString) ---');
  print(ts.toString());

  // Method 2: ts.prettify() (gives formatted full HTML string)
  print('\n--- Prettified Modified HTML (prettify) ---');
  print(ts.prettify());

  print('\n--- 6. Quick Access Helpers ---');
  print('Link href: ${ts.links.first.href}');
  print('Body has story paragraph: ${ts.body?.hasChild("p.story")}');

  print('\n--- 7. XPath Support ---');
  final xpathLinks = ts.xpath('//p[@class="story"]/a');
  print('XPath matched links: ${xpathLinks.map((e) => e.string).toList()}');

  print('\n--- 8. JSON Schema Extraction & Path Generation ---');
  // Use CSS Selectors to pull specific elements directly into a Map
  final data = ts.extractData({
    'productName': 'h1#product_title',
    'cost': '.price',
    'image': 'img.preview@src',
  });
  print('Extracted JSON Data: $data');

  final previewImg = ts.find('img', class_: 'preview')!;
  print('CSS Path for image: ${previewImg.cssPath()}');
  print('XPath for image: ${previewImg.xpathPath()}');

  print('\n--- 9. Sanitization & Markdown ---');
  final maliciousPost = ts.find('div', id: 'post')!;

  // Strip dangerous tags out of the tree
  maliciousPost.sanitize();
  print('Sanitized HTML: ${maliciousPost.outerHtml}');

  // Convert HTML element to Markdown
  print('Markdown output: ${maliciousPost.toMarkdown()}');

  print('\n--- 10. Concurrent Batch Processing ---');
  // Process the same huge document multiple times concurrently
  final massivePagesList = List.generate(5, (_) => html_doc);

  TypedSoup.batch(massivePagesList).then((documents) {
    print(
      'Batch processed ${documents.length} documents concurrently across Isolates.',
    );
    print('First parsed document title: ${documents.first.title?.string}');
  });
}

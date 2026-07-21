import 'package:test/test.dart';
import 'package:typed_soup/typed_soup.dart';

const htmlSample = '''
<!DOCTYPE html>
<html>
  <head>
    <title>Sample Title</title>
  </head>
  <body>
    <header><h1>Header 1</h1><h2>Header 2</h2></header>
    <nav><a href="/home">Home</a><a href="/about">About</a></nav>
    <main>
      <section>
        <article>
          <p>Paragraph 1</p>
          <p>  Paragraph 2 with spacing  </p>
        </article>
      </section>
      <div id="card" class="box active">
        <span>Span Text</span>
        <code>print("hello")</code>
        <pre>Pre formatted</pre>
        <img src="logo.png" alt="Logo" />
        <iframe src="frame.html"></iframe>
      </div>
      <form action="/submit" method="post">
        <label for="name">Name</label>
        <input type="text" id="name" value="John" />
        <select><option>Opt1</option></select>
        <textarea>Notes</textarea>
        <button type="submit">Submit</button>
      </form>
      <table>
        <tr><th>Header Cell</th></tr>
        <tr><td>Data Cell 1</td><td>Data Cell 2</td></tr>
      </table>
      <ul>
        <li>Item 1</li>
        <li>Item 2</li>
      </ul>
    </main>
    <footer>Footer</footer>
  </body>
</html>
''';

void main() {
  group('String Extension Convenience', () {
    test('parseSoup and parseSoupFragment', () {
      final tsDoc = htmlSample.parseSoup();
      expect(tsDoc.title?.string, 'Sample Title');

      final tsFrag = '<div><span class="badge">Badge</span></div>'
          .parseSoupFragment();
      expect(tsFrag.span?.string, 'Badge');
    });
  });

  group('Tag Shortcuts', () {
    final ts = htmlSample.parseSoup();

    test('single tag shortcuts', () {
      expect(ts.div?.id, 'card');
      expect(ts.span?.string, 'Span Text');
      expect(ts.form?.action, '/submit');
      expect(ts.input?.value, 'John');
      expect(ts.button?.type, 'submit');
      expect(ts.header?.name, 'header');
      expect(ts.footer?.trimmedText, 'Footer');
      expect(ts.nav?.links.length, 2);
      expect(ts.main?.name, 'main');
      expect(ts.section?.name, 'section');
      expect(ts.article?.name, 'article');
      expect(ts.li?.string, 'Item 1');
      expect(ts.tr?.name, 'tr');
      expect(ts.th?.string, 'Header Cell');
      expect(ts.td?.string, 'Data Cell 1');
      expect(ts.code?.string, 'print("hello")');
      expect(ts.pre?.string, 'Pre formatted');
      expect(ts.iframe?.src, 'frame.html');
    });

    test('plural collection getters', () {
      expect(ts.links.length, 2);
      expect(ts.paragraphs.length, 2);
      expect(ts.imgs.length, 1);
      expect(ts.divs.length, 1);
      expect(ts.spans.length, 1);
      expect(ts.buttons.length, 1);
      expect(ts.inputs.length, 1);
      expect(ts.forms.length, 1);
      expect(ts.tables.length, 1);
      expect(ts.rows.length, 2);
      expect(ts.cells.length, 3); // 1 th + 2 td
      expect(ts.items.length, 2);
      expect(ts.headings.length, 2); // h1, h2
    });
  });

  group('Attribute Property Accessors', () {
    final ts = htmlSample.parseSoup();

    test('getters and setters', () {
      final link = ts.links.first;
      expect(link.href, '/home');
      link.href = '/new-home';
      expect(link.href, '/new-home');

      final img = ts.img!;
      expect(img.src, 'logo.png');
      expect(img.alt, 'Logo');
      img.src = 'new-logo.png';
      img.alt = 'New Logo';
      expect(img.src, 'new-logo.png');
      expect(img.alt, 'New Logo');

      final input = ts.input!;
      expect(input.type, 'text');
      expect(input.value, 'John');
      input.value = 'Jane';
      expect(input.value, 'Jane');

      final form = ts.form!;
      expect(form.action, '/submit');
      form.action = '/new-submit';
      expect(form.action, '/new-submit');
    });
  });

  group('Element Helpers', () {
    final ts = htmlSample.parseSoup();

    test('trimmedText, hasChild, childrenByTag', () {
      final p2 = ts.paragraphs[1];
      expect(p2.trimmedText, 'Paragraph 2 with spacing');

      final card = ts.div!;
      expect(card.hasChild('span'), isTrue);
      expect(card.hasChild('table'), isFalse);

      final nav = ts.nav!;
      expect(nav.childrenByTag('a').length, 2);
    });
  });

  group('Table Parsing (toTableData)', () {
    test('converts HTML table to list of row maps', () {
      final ts =
          '''
      <table>
        <tr><th>Name</th><th>Age</th><th>Role</th></tr>
        <tr><td>Alice</td><td>30</td><td>Admin</td></tr>
        <tr><td>Bob</td><td>25</td><td>User</td></tr>
      </table>
      '''
              .parseSoup();

      final data = ts.table!.toTableData();
      expect(data.length, 2);
      expect(data[0], {'Name': 'Alice', 'Age': '30', 'Role': 'Admin'});
      expect(data[1], {'Name': 'Bob', 'Age': '25', 'Role': 'User'});
    });
  });

  group('HTML5 Data Attributes (dataAttr & dataAttrs)', () {
    test('reads data-* attributes', () {
      final ts =
          '<div id="user" data-user-id="42" data-role="admin" data-status="active"></div>'
              .parseSoupFragment();

      final div = ts.find('div')!;
      expect(div.dataAttr('user-id'), '42');
      expect(div.dataAttr('data-role'), 'admin');
      expect(div.dataAttrs, {
        'user-id': '42',
        'role': 'admin',
        'status': 'active',
      });
    });
  });

  group('Ancestor Matching (closest & matches)', () {
    test('finds closest matching ancestor', () {
      final ts =
          '''
      <div class="card" id="c1">
        <section class="body">
          <p class="text"><a id="target" href="#">Click</a></p>
        </section>
      </div>
      '''
              .parseSoup();

      final link = ts.find('a', id: 'target')!;
      expect(link.matches('a'), isTrue);
      expect(link.matches('div'), isFalse);

      expect(link.closest('p')?.className, 'text');
      expect(link.closest('div.card')?.id, 'c1');
      expect(link.closest('body'), isNotNull);
      expect(link.closest('footer'), isNull);
    });
  });

  group('Text Lines Cleaning (strippedLines)', () {
    test('strips text lines and filters blanks', () {
      final ts =
          '''
      <div>
        
        Line 1  
        
        Line 2  
        
      </div>
      '''
              .parseSoup();

      expect(ts.div!.strippedLines, ['Line 1', 'Line 2']);
    });
  });

  group('ownText & ownTextTrimmed', () {
    test('extracts text directly belonging to element', () {
      final ts = '<div id="card"> Welcome <span>User</span>! </div>'
          .parseSoupFragment();

      final div = ts.find('div')!;
      expect(div.text, ' Welcome User! ');
      expect(div.ownText, ' Welcome ! ');
      expect(div.ownTextTrimmed, 'Welcome !');
    });
  });

  group('Form Data Serialization (toFormData)', () {
    test('extracts input names and values into map', () {
      final ts =
          '''
      <form action="/login">
        <input name="username" value="john_doe" />
        <input type="password" name="password" value="secret123" />
        <input type="checkbox" name="remember" value="true" checked />
        <input type="checkbox" name="newsletter" value="true" />
        <select name="role"><option value="admin">Admin</option></select>
        <textarea name="bio">Software Dev</textarea>
      </form>
      '''
              .parseSoup();

      final data = ts.form!.toFormData();
      expect(data, {
        'username': 'john_doe',
        'password': 'secret123',
        'remember': 'true',
        'role': 'admin',
        'bio': 'Software Dev',
      });
    });
  });

  group('List Collection Extensions (TsElementListExt)', () {
    test('list helpers hrefs, trimmedTexts, withClass, withAttr', () {
      final ts =
          '''
      <nav>
        <a href="/home" class="item active" data-type="main">Home</a>
        <a href="/about" class="item" data-type="main">About</a>
        <a href="/contact" class="item">Contact</a>
      </nav>
      '''
              .parseSoup();

      final links = ts.links;
      expect(links.hrefs, ['/home', '/about', '/contact']);
      expect(links.trimmedTexts, ['Home', 'About', 'Contact']);
      expect(links.withClass('active').length, 1);
      expect(links.withAttr('data-type', 'main').length, 2);
    });
  });

  group('Custom Predicate Search (findWhere & findAllWhere)', () {
    test('finds elements matching predicate', () {
      final ts = htmlSample.parseSoup();

      final firstNav = ts.findWhere((e) => e.name == 'a' && e.href == '/home');
      expect(firstNav, isNotNull);
      expect(firstNav?.string, 'Home');

      final allHeaders = ts.findAllWhere(
        (e) => e.name != null && e.name!.startsWith('h'),
      );
      expect(allHeaders.length, 5); // html, head, header, h1, h2
    });
  });
}

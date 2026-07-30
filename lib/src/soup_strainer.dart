import 'package:html/dom.dart';
import 'package:typed_soup/typed_soup.dart';

/// SoupStrainer allows memory-efficient iterative parsing of specific tags
/// from a massive HTML document, avoiding the need to parse the entire DOM tree into memory.
class SoupStrainer {
  /// The HTML tag to extract (e.g., 'div', 'p', 'tr').
  final String tag;

  /// Creates a strainer that extracts instances of [tag].
  SoupStrainer(this.tag);

  /// Iteratively yields [TsElement]s matching the tag from the [htmlStr].
  Iterable<TsElement> strain(String htmlStr) sync* {
    final startTag = '<$tag';
    final endTag = '</$tag>';
    int currentIndex = 0;

    while (true) {
      final startIndex = htmlStr.indexOf(startTag, currentIndex);
      if (startIndex == -1) break;

      // Ensure the tag isn't a prefix of another tag (e.g., matching '<div' when looking for '<di')
      final nextChar = htmlStr.length > startIndex + startTag.length
          ? htmlStr[startIndex + startTag.length]
          : ' ';
      if (nextChar != ' ' &&
          nextChar != '>' &&
          nextChar != '\n' &&
          nextChar != '\r') {
        currentIndex = startIndex + startTag.length;
        continue;
      }

      int depth = 1;
      int searchIndex = startIndex + startTag.length;

      while (depth > 0) {
        final nextStart = htmlStr.indexOf(startTag, searchIndex);
        final nextEnd = htmlStr.indexOf(endTag, searchIndex);

        if (nextEnd == -1) break; // Malformed HTML or EOF

        if (nextStart != -1 && nextStart < nextEnd) {
          final nChar = htmlStr.length > nextStart + startTag.length
              ? htmlStr[nextStart + startTag.length]
              : ' ';
          if (nChar == ' ' || nChar == '>' || nChar == '\n' || nChar == '\r') {
            depth++;
          }
          searchIndex = nextStart + startTag.length;
        } else {
          depth--;
          searchIndex = nextEnd + endTag.length;
        }
      }

      if (depth == 0) {
        final chunk = htmlStr.substring(startIndex, searchIndex);
        final ts = TypedSoup.fragment(chunk);
        if (ts.doc.nodes.isNotEmpty && ts.doc.nodes.first is Element) {
          yield (ts.doc.nodes.first as Element).ts;
        }
        currentIndex = searchIndex;
      } else {
        break; // Malformed, can't find closing tags
      }
    }
  }
}

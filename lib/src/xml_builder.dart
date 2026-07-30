import 'package:html/dom.dart' as html;
import 'package:xml/xml.dart' as xml;

/// Converts an XML string into an HTML Document using the xml package
/// to preserve case-sensitivity and CDATA.
html.Document parseXmlToHtmlDocument(String xmlString) {
  final xmlDoc = xml.XmlDocument.parse(xmlString);
  final htmlDoc = html.Document();

  for (final child in xmlDoc.children) {
    _convertAndAppend(child, htmlDoc);
  }

  return htmlDoc;
}

void _convertAndAppend(xml.XmlNode xmlNode, html.Node parent) {
  if (xmlNode is xml.XmlElement) {
    final htmlElement = html.Element.tag(xmlNode.name.qualified);
    for (final attr in xmlNode.attributes) {
      htmlElement.attributes[attr.name.qualified] = attr.value;
    }
    for (final child in xmlNode.children) {
      _convertAndAppend(child, htmlElement);
    }
    parent.append(htmlElement);
  } else if (xmlNode is xml.XmlText) {
    parent.append(html.Text(xmlNode.value));
  } else if (xmlNode is xml.XmlCDATA) {
    parent.append(html.Text(xmlNode.value));
  } else if (xmlNode is xml.XmlComment) {
    parent.append(html.Comment(xmlNode.value));
  }
}

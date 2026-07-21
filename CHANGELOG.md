## 1.0.3

- **Direct Node Text**: Added `element.ownText` and `element.ownTextTrimmed` to extract text belonging solely to the element directly (excluding nested child elements).
- **Form Data Serialization**: Added `form.toFormData()` to serialize form controls (`<input>`, `<select>`, `<textarea>`, `<button>`) into `Map<String, String>`.
- **List Collection Extensions**: Added `TsElementListExt` for easy mapping and filtering (`.hrefs`, `.srcs`, `.texts`, `.trimmedTexts`, `.withClass()`, `.withAttr()`).
- **Custom Predicate Search**: Added `ts.findWhere(predicate)` and `ts.findAllWhere(predicate)` to query elements using custom Dart functions.
- **Table Parsing to Maps**: Added `table.toTableData()` to parse HTML table elements into `List<Map<String, String>>`.
- **HTML5 Data Attributes**: Added `element.dataAttr(name)` and `element.dataAttrs` map getter for `data-*` attributes.
- **Ancestor Matching**: Added `element.closest(selector)` and `element.matches(selector)` to query matching ancestor elements up the tree.
- **Text Lines Utility**: Added `element.strippedLines` to extract trimmed, non-blank text lines.
- **Convenient String Extension**: Added `String.parseSoup()` and `String.parseSoupFragment()`.
- **Expanded Tag Shortcuts & Collections**: Added single tag getters (`div`, `span`, `form`, `input`, `button`, `label`, `selectTag`, `textarea`, `section`, `article`, `header`, `footer`, `nav`, `main`, `li`, `tr`, `td`, `th`, `code`, `pre`, `iframe`) and plural collection getters (`links`, `paragraphs`, `imgs`, `divs`, `spans`, `buttons`, `inputs`, `forms`, `tables`, `rows`, `cells`, `items`, `headings`).
- **Attribute Accessors**: Added `href`, `src`, `alt`, `value`, `type`, `target`, `action` property getters & setters on `TsElement`.

## 1.0.2

- **Prettify Enhancements**: Rewrote `prettify()` with a recursive HTML formatter that outputs clean, 2-space indented HTML trees; added optional `indent` parameter (`prettify({String indent = '  '})`).
- **Standardized Naming**: Updated variable names to `ts` across all code examples, tests, and documentation.
- **Extension Getter**: Added `Element.ts` extension property getter (`Element.ts`).
- **Documentation & Examples**:
  - Replaced external doc links in README with verified inline Dart code examples.
  - Added documentation on in-place tree mutations and exporting modified HTML via `ts.toString()` / `ts.prettify()`.
  - Expanded `example/main.dart` with a complete API feature demonstration.
- **Automated Verification**: Added automated README example test generator (`tool/generate_examples.dart`) and verification suite (`test/readme_examples_test.dart`).
- **Package Distribution**: Added and configured `.gitignore` and `.pubignore` files for clean package publishing.

## 1.0.1

- Updated repository URLs and badges in documentation and package metadata.
- Updated `lints` dev dependency.

## 1.0.0

- **Major Release**: Full API alignment with Python Beautiful Soup 4
- **Package Rename**: Renamed from `beautiful_soup_dart` to `typed_soup`
- **Navigation Methods**:
  - Added `selfAndDescendants` - includes current element with descendants
  - Added `selfAndParents` - includes current element with parents
  - Added `selfAndNextSiblings` - includes current element with next siblings
  - Added `selfAndPreviousSiblings` - includes current element with previous siblings
  - Added `selfAndNextElements` - includes current element with next elements
  - Added `selfAndPreviousElements` - includes current element with previous elements
- **Search Methods**:
  - Added `select()` - CSS selector method for finding all matching elements
  - Added `select_one()` - CSS selector method for finding first matching element
- **Modification Methods**:
  - Added `replaceWithChildren()` - replaces element with its children
  - Added `wrapWithString()` - wraps element with optional string content
  - Made `smooth()` public - consolidates adjacent text nodes
- **Output Methods**:
  - Added `strings` - generator of all strings in document and descendants
  - Added `strippedStrings` - generator of stripped strings (returns Iterable<String>)
- **Element Methods**:
  - Added `get()` - gets attribute value with optional default
- **CSS Selector Support**:
  - Enhanced `:nth-child()` selector support (integers, keywords, formulas)
  - Added `:first-child` selector support
- **Improvements**:
  - Enhanced `prettify()` method to support additional node types
  - Improved recursive search for `nextParsedAll` and `previousParsedAll`
  - Updated all tests to align with new API behavior
- **Documentation**:
  - Updated README with complete feature list
  - Updated all documentation URLs to official Beautiful Soup 4
  - Removed deprecated API references

## 0.3.0

- Added new **Modifying the Tree** methods: `newTag()`, `clear()`, `decompose()`, `wrap()`,
`unwrap()`, `setter for .name (tag name)`.
- Added new parameters to `getText()` **Output** method: `separator`, `strip`.
- Added new **Output** method (partial support): `prettify()`.
- Added new helper methods for element's **attributes**: `removeAttr()`, `hasAttr()`, 
`setAttr()`, `getAttrValue()`.
- Added new **Tags**: `b`, `i`.
- Added tests & coverage.
- Updated README.

## 0.2.0

- Renamed parameter `customSelector` to `selector` in **Searching the Tree** methods.
- Added new parameters to **Searching the Tree** methods: `id`, `class_`, `regex`, 
`string` and `limit`.

## 0.1.0

- Added new **Navigating the Tree** methods: `.nextElement`, `.nextElements`, `.previousElement`,
  `.previousElements`, `.nextParsed`, `.nextParsedAll`, `.previousParsed`, `.previousParsedAll`.
- Added new **Searching the Tree** methods: `findParent()`, `findParents()`, `findNextSibling()`,
  `findNextSiblings()`, `findPreviousSibling()`, `findPreviousSiblings()`,
  `findNextElement()`, `findAllNextElements()`, `findPreviousElement()`, `findAllPreviousElements()`,
  `findNextParsed()`, `findNextParsedAll()`, `findPreviousParsed()`, `findPreviousParsedAll()`.
- Added new **Output** method: `.text`.
- Added more tests. 
- Removed unused dependency.
- Updated README.  
- Improved documentation.

## 0.0.1

- Initial version.

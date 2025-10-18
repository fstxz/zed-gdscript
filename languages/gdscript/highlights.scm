; Class
(class_name_statement (name) @type)
(class_definition (name) @type)


; Function calls

(attribute_call (identifier) @function)
(base_call (identifier) @function)
(call (identifier) @function)

; Function definitions

(function_definition
  name: (name) @function
  parameters: (parameters) @variable)
(constructor_definition "_init" @function)
(lambda (parameters) @variable)


;; Literals
(comment) @comment
((comment) @comment.doc
  (#match? @comment.doc "^##"))
[
  (region_start)
  (region_end)
] @comment.doc
(string) @string

(type) @type
(enum_definition (name) @type)
(enumerator (identifier) @variant)
(null) @type

(variable_statement (identifier) @variable)
(attribute
  (identifier)
  (identifier) @property)

((identifier) @type
  (#match? @type "^(bool|float|int)$"))

[
  (string_name)
  (node_path)
  (get_node)
] @label
(signal_statement (name) @label)

(const_statement (name) @constant)

[
  (integer)
  (float)
] @number

(escape_sequence) @string.escape
[
  (true)
  (false)
] @boolean

[
  "+"
  "-"
  "*"
  "**"
  "/"
  "%"
  "=="
  "!="
  ">"
  "<"
  ">="
  "<="
  "&&"
  "||"
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "^="
  "|="
  "&"
  "|"
  "^"
  "~"
  "<<"
  ">>"
  ":="
  "<<="
  ">>="
  "**="
] @operator

; Keywords
(annotation (identifier) @keyword)

[
  (remote_keyword)
  (static_keyword)
  (breakpoint_statement)
] @keyword

[
  "if"
  "else"
  "elif"
  "match"
  "while"
  "for"
  "return"
  "pass"
  "break"
  "continue"
  "func"
  "in"
  "is"
  "as"
  "and"
  "or"
  "not"
  "var"
  "class"
  "class_name"
  "enum"
  "const"
  "signal"
  "@"
  "setget"
  "onready"
  "extends"
  "set"
  "get"
  "await"
] @keyword

((identifier) @keyword
  (#match? @keyword "^(self|super)$"))

; Identifier naming conventions
; This needs to be at the very end in order to override earlier queries

; Mark identifiers that start with a capital letter as types
(
  (identifier) @type
  (#match? @type "^[A-Z]+"))

(
  (identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]+$"))

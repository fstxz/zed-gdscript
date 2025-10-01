(class_definition
    "class" @context
    name: (_) @name) @item

; Functions. Only capture methods and static functions, not lambdas.
(source
    (function_definition
        "func" @context
        name: (_) @name) @item
)
(class_definition
    (class_body
        (function_definition
            "func" @context
            name: (_) @name) @item
    )
)

(constructor_definition
    "func" @context
    "_init" @name) @item

; Variables. Only capture properties, not local variables.
(source
    (variable_statement
        (annotations
            (annotation (_) @context)
        )
        "var" @context
        name: (_) @name) @item)
(source
    (variable_statement .
        "var" @context
        name: (_) @name
    ) @item)
(class_definition
    (class_body
        ( variable_statement
            "var" @context
            name: (_) @name) @item))

(signal_statement
    "signal" @context
    (name) @name) @item

(enum_definition
    "enum" @context
    name: (_) @name) @item

(source
    (const_statement
        "const" @context
        name: (_) @name) @item)
(class_definition
    (class_body
        (const_statement
            "const" @context
            name: (_) @name) @item))

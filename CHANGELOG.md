# Changelog

This file documents the changes made to the formatter with each release. This project uses [semantic versioning](https://semver.org/spec/v2.0.0.html).

## Release 0.6.0 (2025-10-10)

### Added

- Debugging support
- Auto-closing of quotes and support for auto-closing in brackets
- Syntax highlighting for regions
- Support for GDShader
- Outline view: `_init()` constructor method is now listed

### Changed

- Updated `tree-sitter-gdscript`
- Added highlighting for missing GDScript operators
- Capitalized identifiers are now marked as types
- Strip debug symbols on release builds to reduce download sizes

### Fixed

- Highlight: identifiers in `binary_operator` being incorrectly marked as types
- Highlight: some built-in types not being marked as types
- Capitalized identifiers not being marked as constants

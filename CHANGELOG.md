# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Refactor reporter and parser handling
- Add `format` attribute
- Rename `parser` to `id`

### Removed
- Ruby 2.2 support

### Added 
- ClangParser
- PylintJsonParser

## [0.1.0] - 2019-01-23
### Added 
- PylintParser - Support Pylint formatted reports
- RuboCopParser - Support RuboCop formatted reports

### Changed
- Renamed issue.id to issue.category

### Removed
- Remove issue.name 

## [0.0.1] - 2019-01-21
### Added
- Initial release
- Add [bandit](https://github.com/PyCQA/bandit) parser support

<h1 align="center">danger-warnings</h1>

<div align="center">
  <!-- Sonar Cloud -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/images/project_badges/sonarcloud-white.svg"
      alt="Sonar Cloud" />
  </a>
</div>

</br>

<div align="center">
  <!-- Build Status -->
  <a href="https://travis-ci.org/Kyaak/danger-warnings">
    <img src="https://img.shields.io/travis/choojs/choo/master.svg"
      alt="Build Status" />
  </a>
  <!-- Quality Gate -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=alert_status"
      alt="Quality Gate" />
  </a>
</div>

<div align="center">
  <!-- Reliability Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=reliability_rating"
      alt="Reliability Rating" />
  </a>
  <!-- Security Rating -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=security_rating"
      alt="Security Rating" />
  </a>
  <!-- Maintainabiltiy -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=sqale_rating"
      alt="Maintainabiltiy" />
  </a>
</div>

<div align="center">
  <!-- Code Smells -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=code_smells"
      alt="Code Smells" />
  </a>
  <!-- Bugs -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=bugs"
      alt="Bugs" />
  </a>
  <!-- Vulnerabilities -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=vulnerabilities"
      alt="Vulnerabilities" />
  </a>
  <!-- Technical Dept -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=sqale_index"
      alt="Technical Dept" />
  </a>
</div>

<div align="center">
  <!-- Coverage -->
  <a href="https://sonarcloud.io/dashboard?id=Kyaak_danger-warnings">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=Kyaak_danger-warnings&metric=coverage"
      alt="Coverage" />
  </a>
  <!-- Docs -->
  <a href="http://inch-ci.org/github/Kyaak/danger-warnings">
    <img src="http://inch-ci.org/github/Kyaak/danger-warnings.svg?branch=master"
      alt="Docs" />
  </a>
</div>

</br>

This [danger](https://github.com/danger/danger) plugin provides a uniform report format for various lint [tools](#parser). <br>
The purpose is a simple to use plugin regardless of the linter tool used to create the issues.

## How does it look

### As markdown
**Bandit Report**

Severity|File|Message
---|---|---
Low|example/ply/yacc_1.py:2853|[B403-blacklist] Consider possible security implications associated with pickle module.
Medium|example/ply/yacc_2.py:3255|[B102-exec_used] Use of exec detected.
High|example/ply/yacc_3.py:3255|[B102-exec_used] Use of exec detected.

### As inline comment
```text
Low
[B403-blacklist]
Consider possible security implications associated with pickle module.
```

## Installation

```bash
$ gem install danger-warnings
``` 

## Usage
```text
Methods and attributes from this plugin are available in 
your `Dangerfile` under the `warnings` namespace.
```

#### Minimal example:
```ruby
# Create a bandit report with default settings.
warnings.report(          
  parser: :bandit,
  file: 'reports/bandit.json'         
)
```

#### Simple example: 
```ruby
# Create a bandit report with a custom name, fails if any high warning exists 
# and evaluates all issues (not only the changed files) .
warnings.report( 
  name: 'My Bandit Report',            
  parser: :bandit,
  file: 'reports/bandit.json',
  fail_error: true,
  filter: false         
)
```

#### Complex example:
```ruby
# Define base settings to be applied to all new reporter.
warnings.inline = true
warning.fail_error = true

# Use custom names to separate the table reports in the danger comment. 
warnings.report(
  name: 'Report 1',          
  parser: :bandit,
  file: 'reports/bandit.json'
  # Not necessary because already defined as default.   
  # inline: true,
  # fail_error: true      
)

warnings.report( 
  name: 'Report 2',         
  parser: :bandit,
  file: 'reports/bandit.json'         
  # Not necessary because already defined as default.   
  # inline: true,
  # fail_error: true      
)

warnings.report( 
  name: 'Report 3',         
  parser: :bandit,
  file: 'reports/bandit.json',         
  # Override the newly defined default settings only for this reporter.   
  inline: false,
  fail_error: false      
)
```

## Configuration

#### Override default settings
These values apply to all reports. <br>
It is possible to override the values in the `report` method.

|Field|Default|Description|
|---|---|---|
|warnings.**inline**|`False`| Whether to comment as markdown report or do an inline comment on the file.
|warnings.**filter**|`True`| Whether to filter and report only for changes (modified, created) files. If this is set to false, all issues of a report are included in the comment.
|warnings.**fail_error**|`False`| Whether to fail if any `High` issue is reported.

#### Create a report
The method `warnings.report(*args)` is the main method of this plugin. <br>
Configure the details of your report using the arguments passed by.

|Parameter|Class|Description|
|---|---|---|
|name|`String`| A custom name for this report. If none is given, the parser name is used. Useful to separate different reports using the same common style (e.g. checkstyle).
|parser|`Symbol`, `String`| Define the parser to evaluate the report file. Must be a key of the supported [parser](#parser)
|file|`String`| Path to the file to read and parse.
|baseline|`String`| Define a baseline for your files. Useful if the report removes a path segment but is required to identify them in the repository. E.g. `/src/main/java`

All [default](#override-default-settings) fields can be passed as parameters to `report`.
* inline
* filter
* fail_error

These will override the configuration for this report **only**.

## Parser

|Number|Name|ID|File Format|
|:---:|---|---|---|
|1|[bandit](https://github.com/PyCQA/bandit)|bandit|json|

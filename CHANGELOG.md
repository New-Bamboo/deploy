# Octopress Deploy Changelog

## Current version

###  1.0.0 RC10 - 2014-07-06
- Fix: Pass options to initialization when adding a bucket. [#34](https://github.com/octopress/deploy/pull/34)

## Past versions

###  1.0.0 RC9 - 2014-05-31

- New: S3 header configuration options. [#25](https://github.com/octopress/deploy/issues/25)
- Fix: `site_dir` defaults to `'_site'`. [#29](https://github.com/octopress/deploy/issues/29)
- Fix: A Windows OS issue. [#30](https://github.com/octopress/deploy/pull/30)

###  1.0.0 RC8 - 2014-05-08

- Now using SafeYAML for loading configurations.

###  1.0.0 RC7 - 2014-05-02

- Fixed: `--version` flag.
- Fixed: Moved requiring `pry-debugger` to tests.

### 1.0.0 RC6 - 2014-04-17

- Fixed: CLI options now override config file settings.

### 1.0.0 RC5 - 2014-04-01

- Fixed: `site_dir` config didn't work.


### 1.0.0 RC4 - 2014-03-25

- Added: Octopress Ink documentation site support

### 1.0.0 RC3 - 2014-03-22

#### Minor Enhancements
- Default rsync flags are now `-rltDvz` so they no
  longer try to set file permissions or preserve owner and
  group name on remote. Issue: #19
- Added `flags` config for rsync allows customization of flags.
- Added support for octopress-ink documentation system.
- Added a `update_docs` Rake task to update assets/docs/index.markdown from README.md.

#### Bug Fixes
- No longer stripping forward slashes on remote_path. Issue #18
- `pull` command no longer promises a default directory.


### 1.0.0 RC2 - 2014-03-18
- CHANGE: `add_bucket` command becomes `add-bucket` 

### 1.0.0 RC1 - 2014-03-17
- Initial release

# Changelog

## [0.3.0](https://github.com/scalingo-community/terraform-scalingo-app/compare/v0.2.0...v0.3.0) (2023-09-26)


### ✨ New features

* add automatic log drains for addons ([#10](https://github.com/scalingo-community/terraform-scalingo-app/issues/10)) ([cff3966](https://github.com/scalingo-community/terraform-scalingo-app/commit/cff3966c56b4e3673fac1383b2cf18aed0c8d29c))
* add new type of log_drains and validate input ([6cb4daa](https://github.com/scalingo-community/terraform-scalingo-app/commit/6cb4daa425e6833e9f2475e050db88e6b260b013))


### 👷 Other changes

* better readability for changelog ([60f9398](https://github.com/scalingo-community/terraform-scalingo-app/commit/60f93984a654136d1deb904a662de7efce79e312))
* validate format of input domain variables ([f4f1765](https://github.com/scalingo-community/terraform-scalingo-app/commit/f4f1765402a61935ac41f8b818c3ab6b9d2e277d))


### 📚 Documentation

* add example usage in README ([eda67ef](https://github.com/scalingo-community/terraform-scalingo-app/commit/eda67ef8ffe280326b01d76a131bbe5b07be62e3))
* update README ([bdfc591](https://github.com/scalingo-community/terraform-scalingo-app/commit/bdfc59136c34685a85ecbd2cf8f3b4d8907fbe05))

## [0.2.0](https://github.com/scalingo-community/terraform-scalingo-app/compare/v0.1.0...v0.2.0) (2023-08-22)


### ⚠ BREAKING CHANGES

* change the app link between resources with .id instead of .name to comply with the updated docs of Scalingo provider

### Features

* add sticky_sessions and router_logs variables ([2d9f4bd](https://github.com/scalingo-community/terraform-scalingo-app/commit/2d9f4bd01ab0490c95cedc077ad23595f502d015))


### Bug Fixes

* change the app link between resources with .id instead of .name to comply with the updated docs of Scalingo provider ([349027d](https://github.com/scalingo-community/terraform-scalingo-app/commit/349027dfa2219a30d2e639c6ffe92c0ee783fe9b))
* rename sticky_sessions variable ([9768ea1](https://github.com/scalingo-community/terraform-scalingo-app/commit/9768ea10c636916642ef2ff2f0186e740563f0dd))


### Miscellaneous Chores

* release 0.2.0 ([b8b4995](https://github.com/scalingo-community/terraform-scalingo-app/commit/b8b499570190cea33aabfc4befb43a7b9a684c58))

## 0.1.0 (2023-08-18)


### ⚠ BREAKING CHANGES

* separate review apps and scm integrations settiings

### Features

* add app_id and all_environment_variables outputs ([052064c](https://github.com/scalingo-community/terraform-scalingo-app/commit/052064cd3da514942d91cf2ddeb3a301e815714b))
* add compatibility with scalingo provider v2.1.0 ([93cce40](https://github.com/scalingo-community/terraform-scalingo-app/commit/93cce40c594a6041fdb0e53013cef318aa63cc8e))
* add validation for env vars (cannot be null or empty) ([142079e](https://github.com/scalingo-community/terraform-scalingo-app/commit/142079e6f7e22b70308bd7ba39255d664677c59e))
* first commit containing basic working module ([bc54806](https://github.com/scalingo-community/terraform-scalingo-app/commit/bc54806be19f17afa71698e03973554c7f8ed81e))
* new outputs : origin_domain and log_drain_url ([0309f7d](https://github.com/scalingo-community/terraform-scalingo-app/commit/0309f7d7b2c29c43b4c2e12c33f4a8c48fd4f41d))
* output the current region and domain name ([d02b0d8](https://github.com/scalingo-community/terraform-scalingo-app/commit/d02b0d8a91f1ce5002562188a2ade3699f5ec492))


### Bug Fixes

* error when review apps variable is empty ([416fc29](https://github.com/scalingo-community/terraform-scalingo-app/commit/416fc29a09cb96e888850b580b1335750f7dc33e))
* fix syntax error in url output ([525a5cb](https://github.com/scalingo-community/terraform-scalingo-app/commit/525a5cbf5aaaa7e0bc7f5529a5dba62811552f4f))
* remove the log_drain_url in output because not relevant ([9d69a6e](https://github.com/scalingo-community/terraform-scalingo-app/commit/9d69a6ed5e839dd92d51a8af72c265f4e7f18775))
* replacement is forced when app slug name is used for scalingo_scm_repo_link ([d694595](https://github.com/scalingo-community/terraform-scalingo-app/commit/d69459551ee9bb54045beb180ac8f04451c58698))


### Miscellaneous Chores

* separate review apps and scm integrations settiings ([0291e83](https://github.com/scalingo-community/terraform-scalingo-app/commit/0291e8337aba9b929f04aae31b602adc11bf731b))

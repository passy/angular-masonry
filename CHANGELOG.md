<a name="v0.5.0"></a>
## v0.5.0 (2013-10-11)


#### Bug Fixes

* **app:** watch $scope.$index and reloadItems ([44a9ca29](http://github.com/passy/angular-masonry/commit/44a9ca291d5a1ec96ae4c1b76bfb689add107060), closes [#21](http://github.com/passy/angular-masonry/issues/21))
* **directive:** name anonymous functions ([ca32c03f](http://github.com/passy/angular-masonry/commit/ca32c03f655f20f2b3e7efe9b812f69e76d1e757))


#### Features

* **app:** add masonry.reload event ([774f3fc0](http://github.com/passy/angular-masonry/commit/774f3fc0aad7fccd5f07ae6362926bc61ef435fb))

<a name="v0.4.0"></a>
## v0.4.0 (2013-09-03)


#### Features

* **app:** new options attribute ([ad9b92e5](http://github.com/passy/angular-masonry/commit/ad9b92e5d9254e273ac0810253fca23e6fe4b88b), closes [#10](http://github.com/passy/angular-masonry/issues/10))


#### Breaking Changes

* Options can no longer be specified via the `options` attribute.

Before:

    <masonry options="{my: 'option'}"></masonry>

After:

    <masonry masonry-options="{my: 'option'}"></masonry>

([ad9b92e5](http://github.com/passy/angular-masonry/commit/ad9b92e5d9254e273ac0810253fca23e6fe4b88b))

<a name="v0.3.6"></a>
### v0.3.6 (2013-09-03)


#### Bug Fixes

* **app:** pre-link instead of post-link ([7fe3e85f](http://github.com/passy/angular-masonry/commit/7fe3e85f678909d4b35901910dae0c4f59406c77), closes [#11](http://github.com/passy/angular-masonry/issues/11))


#### Features

* **app:** emit create/destroy events ([6adea921](http://github.com/passy/angular-masonry/commit/6adea921710113f1c0d86339fce919c09ea9c910))

<a name="v0.3.5"></a>
### v0.3.5 (2013-08-21)


#### Features

* **app:** emit create/destroy events ([6adea921](http://github.com/passy/angular-masonry/commit/6adea921710113f1c0d86339fce919c09ea9c910))

<a name="v0.3.4"></a>
### v0.3.4 (2013-08-20)


#### Features

* **build:** include DI annotations in build ([a1051997](http://github.com/passy/angular-masonry/commit/a1051997001c0791e6c3deff2cdee5ec4c2ebe96), closes [#6](http://github.com/passy/angular-masonry/issues/6))

<a name="v0.3.3"></a>
### v0.3.3 (2013-08-07)


#### Bug Fixes

* **app:** add explicit DI annotationss ([aea8e530](http://github.com/passy/angular-masonry/commit/aea8e53070942f5554bb9e1aaac22c3e57f3c08e))


#### Features

* **build:** use ngmin instead of annotations ([1eee22b9](http://github.com/passy/angular-masonry/commit/1eee22b9d2f9e0294c020d7fa8bd66dd8b91a465))

<a name="v0.3.2"></a>
### v0.3.2 (2013-08-04)


#### Bug Fixes

* **app:** enforce new scope for each brick ([ad854df4](http://github.com/passy/angular-masonry/commit/ad854df4e27e952535a0bca20686abaa6cf771db))

<a name="v0.3.1"></a>
### v0.3.1 (2013-08-04)


#### Features

* **app:** expose scheduleMasonry(Once) methods ([0fad6552](http://github.com/passy/angular-masonry/commit/0fad65527af6f1dd11ebc2b3bb2deb03ebaef34c))

<a name="v0.3.0"></a>
## v0.3.0 (2013-08-04)


#### Bug Fixes

* **app:**
  * column width is an integer ([f04d3a2e](http://github.com/passy/angular-masonry/commit/f04d3a2e1369b6aa1dfc84de02ba4ab6925968a6))
  * more careful relayout scheduling ([9b215d6f](http://github.com/passy/angular-masonry/commit/9b215d6f154567823c903319a75fbd13bbc628f9))


#### Features

* **app:** upgraded to masonry 3.1 ([e73c3e62](http://github.com/passy/angular-masonry/commit/e73c3e624fc5ef1a023747caffba5da3794abd8f))

<a name="v0.2.1"></a>
## v0.2.0 (2013-07-22)


#### Bug Fixes

* **app:** scheduled re-layout too early ([a10b6522](http://github.com/passy/angular-masonry/commit/a10b6522c373e0352f53c54bbbe1004ed1297434))

<a name="v0.2.1"></a>
## v0.2.0 (2013-07-17)


#### Bug Fixes

* **app:**
  * remove executions on uninitialized masonry ([ca961fec](http://github.com/passy/angular-masonry/commit/ca961fec27e6ad914eb002ff31a34b2a863b44f9), closes [#1](http://github.com/passy/angular-masonry/issues/1))
  * removed loaded option ([556af9f9](http://github.com/passy/angular-masonry/commit/556af9f945b70bd1c5c14d285ba0e4b29dcd0a60))


#### Features

* **app:** attributes for column-with, item-selector and options ([75b65231](http://github.com/passy/angular-masonry/commit/75b65231c3ec45a79224f46e51a0f58246b4436c))

# Ubuntu Kernel Builder Action

[![Ubuntu Kernel Builder Action](https://github.com/canonical/hwe-packages-build-helpers/actions/workflows/kernel-builder.yml/badge.svg)](https://github.com/canonical/hwe-packages-build-helpers/actions/workflows/kernel-builder.yml)

Ubuntu Kernel Builder Action takes a Ubuntu kernel based Git working repository,
installs the necessary Build-Deps declared by the (generated) debian/control
file, and build the binaries accordingly.

## Usage

To build the default binary target of the checked out kernel tree:

<!-- start usage -->

```yaml
- uses: actions/checkout@v5
- uses: canonical/hwe-packages-build-helpers/actions/kernel-builder@v1
  id: build
- uses: actions/upload-artifact@v4
  if: ${{ !cancelled() }}
  with:
    name: built
    path: |
      ${{ steps.build.outputs.out }}/build.log
      ${{ steps.build.outputs.out }}/*.deb
```

<!-- end usage -->

To build the source package target:

<!-- start usage -->

```yaml
- uses: actions/checkout@v5
- uses: canonical/hwe-packages-build-helpers/actions/kernel-builder@v1
  id: build
  with:
    build-type: source
- uses: actions/upload-artifact@v4
  if: ${{ !cancelled() }}
  with:
    name: built
    path: |
      ${{ steps.build.outputs.out }}/build.log
      ${{ steps.build.outputs.out }}/*.dsc
      ${{ steps.build.outputs.out }}/*_source.changes
      ${{ steps.build.outputs.out }}/*.tar.*
```

<!-- end usage -->

To build from a specific kernel source tree:

<!-- start usage -->

```yaml
- uses: actions/checkout@v5
  with:
    path: linux
- uses: canonical/hwe-packages-build-helpers/actions/kernel-builder@v1
  id: build
  ksrc: linux
- uses: actions/upload-artifact@v4
  if: ${{ !cancelled() }}
  with:
    name: built
    path: |
      ${{ steps.build.outputs.out }}/build.log
      ${{ steps.build.outputs.out }}/*.deb
```

<!-- end usage -->

To skip installation of Build-Deps packages and use a prebuilt container:

<!-- start usage -->

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: ubuntu/devel
    steps:
      - uses: actions/checkout@v5
      - uses: canonical/hwe-packages-build-helpers/actions/kernel-builder@v1
        id: build
        with:
          no-install-deps: true
      - uses: actions/upload-artifact@v4
        if: ${{ !cancelled() }}
        with:
          name: built
          path: |
            ${{ steps.build.outputs.out }}/build.log
            ${{ steps.build.outputs.out }}/*.deb
```

<!-- end usage -->

## Customizing

<!-- start customizing -->

### inputs

The following inputs are available:

| Name            | Required | Description                                                  |
| :-------------- | -------: | :----------------------------------------------------------- |
| ksrc            |    false | The kernel source path. Default: '.'.                        |
| build-type      |    false | `dpkg-buildpackage --build=<build-type>`. Default: 'binary'. |
| no-install-deps |    false | Skip installing Build-Deps. Default: 'false'.                |

### outputs

The following outputs are available:

| Name |   Type | Description                        |
| :--- | -----: | :--------------------------------- |
| out  | string | Actual artifacts output path used. |

<!-- end customizing -->

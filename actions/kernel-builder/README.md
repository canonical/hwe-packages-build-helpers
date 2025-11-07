# Ubuntu Kernel Builder Action

[![Ubuntu Kernel Builder Action](https://github.com/canonical/hwe-packages-build-helpers/actions/workflows/kernel-builder.yml/badge.svg)](https://github.com/canonical/hwe-packages-build-helpers/actions/workflows/kernel-builder.yml)

## Usage

<!-- start usage -->

```yaml
- uses: canonical/hwe-packages-build-helpers/actions/kernel-builder@v1
  id: build
- uses: actions/upload-artifact@v4
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

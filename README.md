# HWE Packages Build Helpers

This project provides GitHub Actions workflow examples for various Ubuntu (only
kernel so far) packages.

## Shared Workflow: Kernel Build

### Usage

Fork this project and send a pull request based on following preconfigured
branches:

<!-- textlint-disable -->

- [linux/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux/noble/latest)
- [linux-oem-6.8/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-oem-6.8/noble/latest)
- [linux-hwe-6.11/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-hwe-6.11/noble/latest)
- [linux-oem-6.11/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-oem-6.11/noble/latest)
- [linux-hwe-6.14/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-hwe-6.14/noble/latest)
- [linux-oem-6.14/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-oem-6.14/noble/latest)
- [linux-hwe-6.17/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-hwe-6.17/noble/latest)
- [linux-oem-6.17/noble/latest](https://github.com/canonical/hwe-packages-build-helpers/tree/linux-oem-6.17/noble/latest)

<!-- textlint-enable -->

You may find a complete list from
[branches list](https://github.com/canonical/hwe-packages-build-helpers/branches/all?query=linux)
.

The pull requests may need further approvals to run the actions. To include this
workflow into your own kernel source tree and runs GitHub Actions from a owned
repository:

<!-- start usage -->

```yaml
jobs:
  build:
    uses: canonical/hwe-packages-build-helpers/.github/workflows/shared-kernel-builder.yml@v1
    with:
      repository: ${{ github.repository }}
      ref: ${{ github.ref }}
```

<!-- end usage -->

### Customizing

<!-- start customizing:shared-kernel-builder.yml -->

#### inputs

The following inputs are available:

| Name           |   Type | Required | Description                                                                                         |
| :------------- | -----: | -------: | :-------------------------------------------------------------------------------------------------- |
| repository     | string |     true | Source repository to checkout. Passed to actions/checkout.                                          |
| ref            | string |     true | Source repository reference to checkout. Passed to actions/checkout.                                |
| artifacts-name | string |    false | Name of the artifact to upload. Passed to actions/upload-artifact. Default: 'artifacts'.            |
| retention-days | number |    false | Duration after which artifact will expire in days. Passed to actions/upload-artifact. Default: '0'. |

#### outputs

The following outputs are available:

| Name            |   Type | Description                                            |
| :-------------- | -----: | :----------------------------------------------------- |
| out             | string | Actual artifacts output path used.                     |
| artifact-id     | string | GitHub ID of an Artifact, can be used by the REST API. |
| artifact-url    | string | URL to download an Artifact.                           |
| artifact-digest | string | SHA-256 digest of an Artifact.                         |

<!-- end customizing -->

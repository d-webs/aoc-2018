---
name: Clone Request
about: For Legacy Catalog Clones
title: "[Legacy Catalog Clone Request] Clones Needed for <Insert Merchant(s) Here>"
labels: something new
assignees: dwebster17

---

## Description

Please assist our Ops team in creating legacy catalog clones.

**Legacy Catalog Link:** Insert Link Here
**Number of Clones**: Insert # Clones Here
**When is this needed by?**:

## Additional Information
<!-- Fill in any additional information, if applicable, below this line -->

---
<!-- DO NOT CHANGE BELOW INFORMATION -->
## For the Developer

### Overview

Copy the script from below, and run it in the postal-main console with the data provided
above.

### Steps

1. Connect to the production postal-console shell
  *  Ensure you are connected to VPN, and logged into the prod k8s cluster with `pmk login prod`
  *  From the postal-main directory, connect to the postal-main shell with `make prod-console-shell`

2. Copy the full contents of [this script][0] into the shell, using the `cpaste` command
3. Call the function `clone_catalog_x_times`.
  * The first argument should be the catalog ID, which can be found in the legacy catalog link above
  * The second argument should be the number of copies, similarly provided above
4. As the function runs, it should print data to stdout. Copy this data, paste it in a comment
   in this issue.
5. Once this is all done, close the issue!

[0]: https://github.com/postmates/merchant-scripts/blob/master/legacy-catalog/clone_catalog.py

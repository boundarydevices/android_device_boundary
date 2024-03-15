/*
 * Copyright 2023 NXP
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 */

package security

import (
  "android/soong/android/allowlists"
)

func init() {
    allowlists.Bp2buildKeepExistingBuildFile["device/boundary/common/security"] = false
}

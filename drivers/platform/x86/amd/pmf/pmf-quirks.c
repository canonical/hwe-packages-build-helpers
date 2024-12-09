// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * AMD Platform Management Framework Driver Quirks
 *
 * Copyright (c) 2024, Advanced Micro Devices, Inc.
 * All Rights Reserved.
 *
 * Author: Mario Limonciello <mario.limonciello@amd.com>
 */

#include <linux/dmi.h>

#include "pmf.h"

struct quirk_entry {
	u32 supported_func;
};

static struct quirk_entry quirk_no_sps_bug = {
	.supported_func = 0x4003,
};

static const struct dmi_system_id fwbug_list[] = {
	{
		.ident = "ROG Zephyrus G14",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
			DMI_MATCH(DMI_PRODUCT_NAME, "GA403U"),
		},
		.driver_data = &quirk_no_sps_bug,
	},
	{
		.ident = "ROG Ally X",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
			DMI_MATCH(DMI_PRODUCT_NAME, "RC72LA"),
		},
		.driver_data = &quirk_no_sps_bug,
	},
	{
		.ident = "ASUS TUF Gaming A14",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
			DMI_MATCH(DMI_PRODUCT_NAME, "FA401W"),
		},
		.driver_data = &quirk_no_sps_bug,
	},
	{}
};

static const struct dmi_system_id platform_prefers_bios_list[] = {
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D47"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D48"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D5F"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D60"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D4D"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D4E"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D61"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D5C"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D5D"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D65"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D49"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D5E"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D4F"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D50"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D51"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D53"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D54"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D52"),
		},
	},
	{
		.ident = "Dell",
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
			DMI_MATCH(DMI_PRODUCT_SKU, "0D55"),
		},
	},
	{}
};

void amd_pmf_quirks_init(struct amd_pmf_dev *dev)
{
	const struct dmi_system_id *dmi_id;
	struct quirk_entry *quirks;

	dmi_id = dmi_first_match(fwbug_list);
	if (!dmi_id)
		return;

	quirks = dmi_id->driver_data;
	if (quirks->supported_func) {
		dev->supported_func = quirks->supported_func;
		pr_info("Using supported funcs quirk to avoid %s platform firmware bug\n",
			dmi_id->ident);
	}
}

bool amd_pmf_prefer_bios()
{
	const struct dmi_system_id *dmi_id;

	dmi_id = dmi_first_match(platform_prefers_bios_list);

	if (dmi_id)
		return true;

	return false;
}

return {
	vendorName = "Linksys",
	deviceName = "WRT1900ACS",
	boardName = "linksys-shelby",
	partition1MTD = "mtd4",
	partition2MTD = "mtd6",
	labelOffset = 32,
	bootEnv1 = "boot_part",
	bootEnv1Partition1Value = 1,
	bootEnv1Partition2Value = 2,
	bootEnv2 = "bootcmd",
	bootEnv2Partition1Value = "run nandboot",
	bootEnv2Partition2Value = "run altnandboot"
}

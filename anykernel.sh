### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# begin properties
properties() { '
kernel.string=SWIFT Kernel by @TTTT55
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
supported.versions=
supported.patchlevels=
'; } # end properties

### AnyKernel install
override_cmdline() {
local cmdline='androidboot.hardware=qcom lpm_levels.sleep_disabled=1 service_locator.enable=1 androidboot.usbcontroller=4e00000.dwc3 swiotlb=0 loop.max_part=7 iptable_raw.raw_before_defrag=1 ip6table_raw.raw_before_defrag=1 firmware_class.path=/vendor/firmware buildvariant=user'
sed -i '/^cmdline/d' $split_img/header;
echo cmdline=$cmdline >> $split_img/header;
}

## boot shell variables
block=boot;
is_slot_device=auto;
no_block_display=1;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

if [ -e $home/KSU_UNLOCK ]; then
    ui_print " " "Flashing KernelSU version. You have been warned about security implications.";
    $bin/bspatch $home/Image $home/Image_ksu $home/ksu.bdf;
    mv -f $home/Image_ksu $home/Image;
fi;

# boot install
split_boot;
flash_boot;
## end boot install

## vendor_boot shell variables
block=vendor_boot;
is_slot_device=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
split_boot;
override_cmdline;
flash_boot;
## end vendor_kernel_boot install

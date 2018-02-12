Building
========

Run the './build' script.

Usage: ./build [-d|-e|-D|-h|--help] [TARGET_NAME]
TARGET_NAME - hardware type to build the image for
-d - make debug build of the agent
-D - recompile the agent ibinary only, debug is ON, no new firmware
-e - buld with -j1 to see errors
-h/--help - this help
Available targets:
archer_c7_v2
... (run ./build -h to see all)

You can set MINIM_DEFAULT_TARGET environment variable in the
shell to the name of the target you want the script to pick
automatically if nothing is specified on the command line.
The agent repository should be accessible under ../unum-v2
or in the location pointed to by MINIM_UNUM_DIR environment
variable.

Example:
export MINIM_DEFAULT_TARGET=archer_c7_v2
./build

The "archer_c7_v2" is the name of the hardware in the Minim system.


Adding hardware support
=======================

1. Find the official release for the target hardware. Start here:
   https://downloads.lede-project.org/releases/17.01.4/targets/
   For example, for "Archer C7 v2", go to "ar71xx" (this board TYPE), then to
   "generic" (board subtype), then download the firmware for the
   specific device "archer-c7-v2-squashfs-sysupgrade.bin" in this case.

2. Try to load the firmware and make sure the device is fully supported.

3. Scroll all the way down and download the base config file for the
   board TYPE/SUBTYPE (the name is "config.seed").
   Save it under name "MINIM_HARDWARE_TYPE.baseconfig" where
   MINIM_HARDWARE_TYPE is the name of the hardware in the Minim system.
   Note: since the base file is the same for all hardware types
         sharing the same hardware board use generic TYPE/SUBTYPE name
         and symlinks for the base config file.

4. Create <MINIM_HARDWARE_TYPE>.diffconfig file by copying any existent one
   and editing the board selection options. Normally, you only need to
   change the options in that file (i.e. the hardware base board type,
   subtype, device name etc...). Make sure the CONFIG_VERSION_HWREV
   and CONFIG_VERSION_PRODUCT form the proper TARGET_NAME for the build.

5. Use "git add" to add the new and/or changed files to git cache.

6. Run the build and verifiy that the new image works correctly.

7. Use "git add" to add the new packages and/or feeds that were
   downloaded for the new hardware type to the cache and commit
   all the canges for the new hardware in a single commit.

Upgrading to a new release
==========================

1. Merge changes from the LEDE release branch tag.

2. Resolve conflicts if any (so far there are only a few
   changes in the LEDE files).

3. If the changes are made to the "./feeds.conf.default" then
   update the location of the feeds in the feeds downloader
   script ./local-feeds/update_local_feeds.sh and run it to
   download the updated feeds.
   Note: the LEDE release build appear to be loading feeds form a branch
         (currently 17.01) which means they could have changed after the
         release was made, therefore if it is necessary to use the exact
         versions of the feeds used for the release then the downloader
         script has to use specific SHAs the releases were built from
         (and I do not know how to get them)

3. Build and test all the supported hardware types. Note all the
   updated feeds and packages downladed during the build.

4. If there were updated feeds and/or packages downloaded commit them
   together with the merged files.

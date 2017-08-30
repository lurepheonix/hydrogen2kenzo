#!/bin/sh

#Preparation

export PATCHROM=`pwd`
cd $PATCHROM
INPUT="$1"
export OUT_DIR="$PATCHROM/out"
export WORK_DIR="$PATCHROM/work"
export APP="$PATCHROM/work/system/app"
export PAPP="$PATCHROM/work/system/priv-app"
export FRAME="$PATCHROM/work/system/framework"
export APKDIR="$PATCHROM/work/apktool"
export TOOLS="$PATCHROM/tools"
export APKTOOL="java -jar $PATCHROM/tools/apktool.jar"
export BUILD_DATE=`date "+%m-%d-%y"`
export PREBUILT="$PATCHROM/prebuilt"
echo -e "\e[1m\e[32mNIBIRU patchrom 0.1 beta\e[39m"
echo -e "\e[1m\e[32mChecking for previous build and removing it if exists\e[39m"
if [ -d $WORK_DIR/ ];
then sudo rm -rf $WORK_DIR/
fi
if [ -d $OUT_DIR/ ];
then rm -rf $OUT_DIR/
fi
echo -e "\e[1m\e[32mMaking out directory\e[39m"
mkdir -p $OUT_DIR

#Unpacking and preparing to work

echo -e "\e[1m\e[32mUnzipping archive\e[39m"
unzip -d work $INPUT 
echo -e "\e[1m\e[32mInitial preparation: remove old firmware\e[39m"
rm -rv $WORK_DIR/META-INF
rm $WORK_DIR/firmware-update/*
echo -e "\e[1m\e[32mCopying new firmware\e[39m"
cp $PREBUILT/firmware-update/* $WORK_DIR/firmware-update/
echo -e "\e[1m\e[32mUnpacking system.new.dat\e[39m"
$TOOLS/sdat2img.py work/system.transfer.list work/system.new.dat work/system.img
if [ ! -d "/system" ];
then sudo mkdir -p /system && echo -e "\e[1m\e[32mCreated /system folder\e[39m"
fi
echo -e "\e[1m\e[32mMounting system.img at /system\e[39m"
sudo mount -t ext4 -o loop $WORK_DIR/system.img /system
echo -e "\e[1m\e[32mUnpacking system.img to workdir\e[39m"
mkdir -p $WORK_DIR/system
cp -rvf /system/* $WORK_DIR/system
echo -e "\e[1m\e[32mUnmounting /system\e[39m"
sudo umount /system
echo -e "\e[1m\e[32mDeleting .dat files\e[39m"
rm $WORK_DIR/system.img $WORK_DIR/system.new.dat $WORK_DIR/system.patch.dat $WORK_DIR/system.transfer.list

#Copying new files and patching

echo -e "\e[1m\e[32mCopying new prebiult files\e[39m"
cp -rvf $PREBUILT/system/* $WORK_DIR/system/

echo -e "\e[1m\e[32mPatching system files\e[39m"

#APKtool | will do this part once done with fixing bugs

#mkdir -p $APKDIR

#echo -e "\e[1m\e[32mPatching files via apktool\e[39m"
#cp $FRAME/framework-res.apk $APKDIR
#cp $FRAME/framework-ext-res/framework-ext-res.apk $APKDIR
#cp $FRAME/services.jar $APKDIR
#cp $FRAME/core-libart.jar $APKDIR
#cp $APP/miui/miui.apk $APKDIR
#cp $APP/miuisystem/miuisystem.apk $APKDIR
#cp $PAPP/InCallUI/InCallUI.apk $APKDIR
#cp $PAPP/MiuiCamera/MiuiCamera.apk $APKDIR
#cp $PAPP/TeleService/TeleService.apk $APKDIR
#cp $PAPP/Settings/Settings.apk $APKDIR
#cd $APKDIR

#echo -e "\e[1m\e[32mInstalling frameworks\e[39m"
#$APKTOOL if $APKDIR/framework-res.apk
#$APKTOOL if $APKDIR/framework-ext-res.apk
#$APKTOOL if $APKDIR/miui.apk
#$APKTOOL if $APKDIR/miuisystem.apk

#echo -e "\e[1m\e[32mDecompiling apks and jars\e[39m"
#$APKTOOL d $APKDIR/services.jar
#$APKTOOL d $APKDIR/core-libart.jar
#$APKTOOL d $APKDIR/InCallUI.apk
#$APKTOOL d $APKDIR/MiuiCamera.apk
#$APKTOOL d $APKDIR/TeleService.apk
#$APKTOOL d $APKDIR/Settings.apk

#echo -e "\e[1m\e[32mApplying patches to apks\e[39m"
#cp $PATCHROM/nibiru_patches/*.patch $APKDIR
# InCallUI
#patch -p1 < $APKDIR/call_recorder.patch
# TeleService
#patch -p1 < $APKDIR/TeleService.patch
# services.jar
#patch -p1 < $APKDIR/vibra.patch
#patch -p1 < $APKDIR/apksignature.patch
# MiuiCamera
#patch -p1 < $APKDIR/camera_jpeg.patch
# Settings
#patch -p1 < $APKDIR/enableDocumentsUI.patch
# core.libart.jar 
#patch -p1 < $APKDIR/apksignature_v2.patch
# Settings & services.jar: previous app on long press patch
#patch -p1 < $APKDIR/prev_app.patch
#patch -p1 < $APKDIR/

#echo -e "\e[1m\e[32mCompiling apks and jars\e[39m"
# Sometimes there are .orig files left, and apktool build fails as resources are redefined
#find . -name "*.orig" -type f -delete
#$APKTOOL b -c services.jar.out
#$APKTOOL b -c core-libart.jar.out
#$APKTOOL b -c InCallUI
#$APKTOOL b -c MiuiCamera
#$APKTOOL b -c TeleService
#$APKTOOL b -c Settings

#echo -e "\e[1m\e[32mReplacing original files with patched\e[39m"
#cp -vf $APKDIR/InCallUI/dist/InCallUI.apk $PAPP/InCallUI/InCallUI.apk
#cp -vf $APKDIR/TeleService/dist/TeleService.apk $PAPP/TeleService/TeleService.apk
#cp -vf $APKDIR/services.jar.out/dist/services.jar $FRAME/services.jar
#cp -vf $APKDIR/core-libart.jar.out/dist/core-libart.jar $FRAME/core-libart.jar
#cp -vf $APKDIR/MiuiCamera/dist/MiuiCamera.apk $PAPP/MiuiCamera/MiuiCamera.apk
#cp -vf $APKDIR/Settings/dist/Settings.apk $PAPP/Settings/Settings.apk
#echo -e "\e[1m\e[32mRemoving Personal Assistant\e[39m"
#rm -rv $PAPP/PersonalAssistant

echo -e "\e[1m\e[32mPatching build.prop\e[39m"
# Audio offload disable
#echo "audio.offload.disable=1" >> $WORK_DIR/system/build.prop
# Headphones buttons: switch tracks by default
#echo "persist.sys.button_jack_profile=music" >> $WORK_DIR/system/build.prop
# Time zone: Moscow
sed -i 's#persist.sys.timezone=Europe/Berlin#persist.sys.timezone=Europe/Moscow#g' $WORK_DIR/system/build.prop
# Enable Camera2 API
echo "persist.camera.HAL3.enabled=1" >> $WORK_DIR/system/build.prop
# Hydrogen -> Kenzo
sed -i 's/ro.build.flavor=hydrogen-user/ro.build.flavor=kenzo-user/g' $WORK_DIR/system/build.prop
sed -i 's/ro.product.name=hydrogen/ro.product.name=kenzo/g' $WORK_DIR/system/build.prop
sed -i 's/ro.product.device=hydrogen/ro.product.device=kenzo/g' $WORK_DIR/system/build.prop
sed -i 's/ro.build.product=hydrogen/ro.build.product=kenzo/g' $WORK_DIR/system/build.prop
sed -i 's/ro.product.model=Max/ro.product.model=kenzo/g' $WORK_DIR/system/build.prop
sed -i 's/ro.product.mod_device=hydrogen_mam_global/ro.product.mod_device=kenzo_global/g' $WORK_DIR/system/build.prop
sed -i 's#ro.build.fingerprint=Xiaomi/hydrogen/hydrogen:6.0.1/MMB29M/V8.2.5.0.MBCMIDL:user/release-keys#ro.build.fingerprint=Xiaomi/kenzo/kenzo:6.0.1/MMB29M/7.7.20:user/release-keys#g' $WORK_DIR/system/build.prop
sed -i 's#ro.bootimage.build.fingerprint=Xiaomi/hydrogen/hydrogen:6.0.1/MMB29M/V8.2.5.0.MBCMIDL:user/release-keys#ro.bootimage.build.fingerprint=Xiaomi/kenzo/kenzo:6.0.1/MMB29M/7.7.20:user/release-keys#g' $WORK_DIR/system/build.prop
sed -i 's/ro.build.description=hydrogen-user 6.0.1 MMB29M V8.2.5.0.MBCMIDL release-keys/ro.build.description=kenzo-user 6.0.1 MMB29M 7.7.20 release-keys/g' $WORK_DIR/system/build.prop
# Possible Goodix fix
sed -i 's/ro.hardware.fingerprint=fpc/#ro.hardware.fingerprint=fpc/g' $WORK_DIR/system/build.prop
sed -i 's/audio.offload.pcm.16bit.enable=true/audio.offload.pcm.16bit.enable=false/g' $WORK_DIR/system/build.prop
sed -i 's/audio.offload.pcm.24bit.enable=true/audio.offload.pcm.24bit.enable=false/g' $WORK_DIR/system/build.prop
#sed -i 's/#tunnel.decode=true/tunnel.decode=true/g' $WORK_DIR/system/build.prop
#sed -i 's/#tunnel.audiovideo.decode=true/tunnel.audiovideo.decode=true/g' $WORK_DIR/system/build.prop
#sed -i 's/#lpa.decode=false/lpa.decode=true/g' $WORK_DIR/system/build.prop
#sed -i 's/#lpa.use-stagefright=true/lpa.use-stagefright=true/g' $WORK_DIR/system/build.prop
sed -i 's/CLS_H_LP/CLS_H_HIFI/g' $WORK_DIR/system/etc/mixer_paths_wcd9326.xml
sed -i 's/CLS_H_LP/CLS_H_HIFI/g' $WORK_DIR/system/etc/mixer_paths_wcd9335.xml
#sed -i 's/original/new/g' $WORK_DIR/system/build.prop

# Replacing kernel with the nibiru one
echo -e "\e[1m\e[32mReplacing and patching kernel\e[39m"
echo -e "\e[1m\e[32mUnpacking kernel\e[39m"
mkdir -p $WORK_DIR/boot/
mkdir -p $WORK_DIR/boot/extracted
$TOOLS/unpackbootimg -i $WORK_DIR/boot.img -o $WORK_DIR/boot/
cd $WORK_DIR/boot/extracted
echo -e "\e[1m\e[32mExtracting ramdisk\e[39m"
gunzip -c $WORK_DIR/boot/boot.img-ramdisk.gz | cpio -i
#echo -e "\e[1m\e[32mPatching init.rc\e[39m"
#cp -v $PATCHROM/nibiru_patches/msmhotplug.patch msmhotplug.patch
#patch -p1 < msmhotplug.patch
cp -v $PATCHROM/nibiru_patches/boot/libshims.patch libshims.patch
patch -p1 < libshims.patch
echo -e "\e[1m\e[32mReplacing and patching files\e[39m"
cp -vf $PREBUILT/boot/fstab.qcom $WORK_DIR/boot/extracted/fstab.qcom
echo -e "\e[1m\e[32mPacking ramdisk\e[39m"
find . | sudo cpio -o -H newc | gzip > $WORK_DIR/boot/patched-ramdisk.gz
echo -e "\e[1m\e[32mPacking kernel\e[39m"
$TOOLS/mkbootimg --kernel $PREBUILT/zImage --ramdisk $WORK_DIR/boot/patched-ramdisk.gz --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk snd-soc-msm8x16-wcd.high_perf_mode=1 androidboot.selinux=permissive"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --kernel_offset 0x00008000 -o $WORK_DIR/boot/boot.img
cp -vf $WORK_DIR/boot/boot.img $WORK_DIR/boot.img
# Making the out rom

echo -e "\e[1m\e[32mMoving all the necessary files to the out directory\e[39m"
cp -rv $WORK_DIR/cust $OUT_DIR/
cp -rv $WORK_DIR/firmware-update $OUT_DIR/
cp -rv $PREBUILT/META-INF $OUT_DIR/
cp -rv $WORK_DIR/system $OUT_DIR/
cp -v $WORK_DIR/boot.img $OUT_DIR/
cp -v $WORK_DIR/file_contexts.bin $OUT_DIR/
#cp -v $PREBUILT/system.img $OUT_DIR/
#echo -e "\e[1m\e[32mMounting /system and copying files back\e[39m"
#sudo mount $OUT_DIR/system.img /system
#sudo rm -rf /system/*
#sudo cp -rv $WORK_DIR/system/* /system/
#sudo umount /system
echo -e "\e[1m\e[32mCleaning up\e[39m"
sudo rm -rf $WORK_DIR/
#rm -rf $OUT_DIR/system/priv-app/Browser
cd $OUT_DIR
echo -e "\e[1m\e[32mZipping\e[39m"
zip -r out.zip .
echo -e "\e[1m\e[32mSigning\e[39m"
java -jar $TOOLS/testsign.jar out.zip $PATCHROM/nibiru-$BUILD_DATE.zip
echo -e "\e[1m\e[32mJob done\e[39m"
# echo -e "\e[1m\e[32m\e[39m"

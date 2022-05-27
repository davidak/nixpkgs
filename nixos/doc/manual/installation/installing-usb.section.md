# Booting from a USB flash drive {#sec-booting-from-usb}

The image has to be written verbatim to the USB flash drive for it to be
bootable on UEFI and BIOS systems. Here are the recommended tools to do that.

## Creating bootable USB flash drive with a graphical tool {#sec-booting-from-usb-graphical}

Etcher is a popular and user-friendly tool. It works on Linux, Windows and macOS.

Download it from [balena.io](https://www.balena.io/etcher/), start the program,
select the downloaded NixOS ISO, then select the USB flash drive and flash it.

::: {.warning}
Etcher reports errors and usage statistics by default, which can be disabled in
the settings. Some users might not like that.
:::

An alternative is [USBImager](https://gitlab.com/bztsrc/usbimager/#usbimager),
which is very simple and does not connect to the internet. Download the version
with write-only (wo) interface for your system. Start the program,
select the image, select the USB flash drive and click "Write".

## Creating bootable USB flash drive from Terminal on Linux {#sec-booting-from-usb-linux}

Use the `dd` utility to write the image to the USB flash drive:

```ShellSession
sudo dd if=<path-to-image> of=/dev/sdX bs=4M conv=fsync oflag=direct status=progress
```

Be careful to replace `sdX` with the correct device! You can use the `lsblk`
command to get a list of block devices and their sizes.

## Creating bootable USB flash drive from Terminal on macOS {#sec-booting-from-usb-macos}

Use the `dd` utility to write the image to the USB flash drive. Unmount the disk before.

```ShellSession
diskutil unmountDisk diskX
sudo dd if=<path-to-image> of=/dev/rdiskX bs=1m
```

Be careful to replace `rdiskX` with the correct device! You can use
the `diskutil list` command to get a list of block devices and their sizes.

Using the \'raw\' `rdiskX` device instead of `diskX` completes in
minutes instead of hours. After `dd` completes, a GUI dialog \"The disk
you inserted was not readable by this computer\" will pop up, which can
be ignored.

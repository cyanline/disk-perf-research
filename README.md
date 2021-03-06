Research method
==================

In general, a forensic acquisition must copy every byte of data from a source disk drive and write it to a target disk drive or target file. As diskto disk copies for forensic images are not typically used anymore, the research focused on disk to file forensic imaging.

When performing a disk to file forensic image, data is read sequentially from the source disk and copied to the target file. In theory, thisprocessshould only be limited by the maximum sustained transfer rate (MSTR). This rate is the rate that a disk drive can respond to read requests when read request can not be satisfied by the disk drive's cache. (A disk drive's burst transferrate will provide information on how fast thedisk drive's cache is. This value is not useful when performing a forensic acquisition as the data needed will not be in cache.)

Stable research environment
---------------------------

A consistent, stable hardware and software environment is the basis for the proper collection of experimental data. Therefore, testing was performed on limited hardware which support SATA, IDE, Firewire and USB2.0. The operating system used was Linux version 2.6.21+.

Small scripts were written in order to manipulate variables on a consistent basis. The data collected from these runs was then saved and later converted into comma separated value (csv) files.

For data input testing, two SATA disks were used during the disk read testing. They were:

    * Hitachi 160 GB disk drive 5400 rpm disk drive.
    * Intel 80 GB Solid State Disk Drive.

These disks were accessed natively via their SATA interfaces.

An IDE disk was used, as well as an external disk that support USB 2.0and firewire 400/800.

Data output metrics, by interface and by filesystem
------------------------------------------------------

As for output, a SATA disk was used. This disk was formatted using NTFS, FAT and Linux EXT2/3/4 filesystems.

Data format tpyes dd, EWF
----------------------------

As for the output of the forensic image, a raw "dd" was used as well as the EWF output format.

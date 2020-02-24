# linuxTricks
## List of tiny linux tricks

- [switchscreen.sh](https://github.com/bekhzod0725/linuxTricks/blob/master/switchscreen.sh) - Provides an easy switch between multiple screens<br/>
<span style="padding-left:5em">**Note!** This script works only if your video card doesn't provide eyefinity support and can support upto 3 screens</span>

- [dud.sh](https://github.com/bekhzod0725/linuxTricks/blob/master/dud.sh) - List out file sizes in a given directory in a sorted manner. Helpful when comparing multiple duplicate folders.

- [fixaudio.sh](https://github.com/bekhzod0725/linuxTricks/blob/master/fixaudio.sh) - Fix audio and video syncing issues caused during screen recording using **recordmydesktop** with on the fly encoding enabled.

## Non-scripted tricks

- Create ISO from CD/DVD
    1. Reading the block size and the volume size:

      [root@testserver ~]# isoinfo -d -i /dev/cdrom | grep -i -E 'block size|volume size' 
      Logical block size is: 2048
      Volume size is: 327867

    2. Running dd with the parameters for block size and volume size:

      [root@testserver ~]# dd if=/dev/cdrom of=test.iso bs=<block size from above> count=<volume size from above>
    - _source:_ https://www.thomas-krenn.com/en/wiki/Create_an_ISO_Image_from_a_source_CD_or_DVD_under_Linux

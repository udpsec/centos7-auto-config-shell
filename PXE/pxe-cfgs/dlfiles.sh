curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig
# https://stable.release.core-os.net/amd64-usr/current/
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2.DIGESTS
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2.DIGESTS.asc
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2.DIGESTS.sig
curl -O  https://stable.release.core-os.net/amd64-usr/current/coreos_production_image.bin.bz2.sig
echo please move vmlinuz and image.cpio.gz to tftpboot / dir.
echo please move image.bin.gz to DocumentRoot/BUILDNUM/

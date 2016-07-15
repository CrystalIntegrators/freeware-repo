# Get main file systems  out of the protoytpe
#
# --------------------------------------------------------------------------
# $Id: $
# --------------------------------------------------------------------------

/\ opt\ /d
/\ usr\ /d
/\ etc\ /d
/\ etc\/inet\ /d
/\ etc\/init\.d\/apache\=/d
/\ etc\/init\.d\ /d
/\ etc\/rc0\.d\ /d
/\ etc\/rc2\.d\ /d
/\ etc\/rc3\.d\ /d
#
# change special case classes to edits
#
s/^f \(build\)/e \1/
s/^f \(sed\)/e \1/
s/^f \(awk\)/e \1/
#
# change perm/owner/group to ? ? ?
#
/^e /s/[0-7]\{4\} [a-zA-Z0-9]\{1,30\} [a-zA-Z0-9]\{1,30\}$/\? \? \?/g

/^d.local.bin/d
/^d.local.conf/d

#
# File: ICEgit/scripts/sedscripts/prototpye.sed
#
# Note: none
#
# --------------------------------------------------------------------------
# $Id: prototype.sed 4 2012-11-15 21:43:41Z svwebadmin $
# --------------------------------------------------------------------------
/\ opt\ /d
/\ usr\ /d
/\ etc\ /d
/\ etc\/inet\ /d
/\ etc\/init.d\ /d
/\ etc\/rc0.d\ /d
/\ etc\/rc2.d\ /d
/\ etc\/rc3.d\ /d
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

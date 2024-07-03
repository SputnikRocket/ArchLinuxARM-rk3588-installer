

#check if profile exists and import setting
check-if-exists "${PROFILEDIR}/${PROFILE}"
source-script "${PROFILEDIR}/${PROFILE}/install.sh"

#check if platform exists and import settings
check-if-exists "${PLATFORMDIR}/${PLATFORM}"
source-script "${PLATFORMDIR}/${PLATFORM}/install.sh"

#check if distro conf exists
check-if-exists "configs/distro/${DISTRO}.sh"
source-script "configs/distro/${DISTRO}.sh"

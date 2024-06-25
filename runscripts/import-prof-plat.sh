

#check if profile exists and import setting
check-if-exists "${PROFILEDIR}/${PROFILE}"
set-profile "${PROFILE}"

#check if platform exists and import settings
check-if-exists "${PLATFORMDIR}/${PLATFORM}"
set-platform "${PLATFORM}"

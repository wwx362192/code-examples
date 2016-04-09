#! /bin/bash

fstab_file=/etc/fstab
disk_path=/Volumes/
disks_ntfs=$(diskutil list | grep Windows_NTFS | awk -F ':' '{print $2}' | sed 's/^[ ]*Windows_NTFS[ ]*//')
IFS=$(echo -en "\n\b")
fileNames=$(ls -v ${disk_path})
# clear fstab file
sudo sh -c "echo '' > ${fstab_file}"
for file in ${fileNames}; do
	if [[ -d "${disk_path}${file}" ]]; then
		for disk_ntfs in ${disks_ntfs}; do
			if [[ ${disk_ntfs} =~ ${file} ]]; then
				# add a ntfs disk
				file=${file// /\\040}' none ntfs rw,auto,nobrowse'
				sudo sh -c "echo ${file} >> ${fstab_file}"
				sudo sh -c "echo '\n' >> ${fstab_file}"
			fi
		done
	fi
done
# create the disk link
ln -s ${disk_path} ~/Desktop/
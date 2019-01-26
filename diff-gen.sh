#!/bin/bash
curr_files=()
orig_files=()
diff_files=()
# SSD
curr_files+=(/etc/ssh/sshd_config)
orig_files+=(/etc/ssh/sshd_config.original_copy)
diff_files+=(/etc/ssh/sshd_config.diff)
# motion
curr_files+=(/etc/motion/motion.conf)
orig_files+=(/etc/motion/original_motion.conf)
diff_files+=(/etc/motion/motion.conf.diff)
# UFW
curr_files+=(/etc/ufw/ufw.conf		/etc/ufw/user.rules		/etc/ufw/user6.rules)
orig_files+=(/etc/ufw/original_ufw.conf	/etc/ufw/original_user.rules	/etc/ufw/original_user6.rules)
diff_files+=(/etc/ufw/ufw.conf.diff     /etc/ufw/user.rules.diff	/etc/ufw/user6.rules.diff)

for (( i=0; i<${#curr_files[@]}; i++ )) do
	if [ -e ${diff_files[i]} ]
	then
		echo "$(ls -ldh ${diff_files[i]})"
		read -p "Rewrite?" rewrite
		if [ ! -z $rewrite ] && [ ! $rewrite == "y" ] && [ ! $rewrite == "Y" ]
		then
			continue
		fi
	fi
	echo "Writing ${diff_files[i]}"
	diff --unified=0 "${orig_files[i]}" "${curr_files[i]}" > "${diff_files[i]}"
done

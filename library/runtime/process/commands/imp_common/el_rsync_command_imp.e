note
	description: "[
		Implementation of ${EL_RSYNC_COMMAND_I} with Unix [https://linux.die.net/man/1/rsync rsync command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 13:57:13 GMT (Friday 28th March 2025)"
	revision: "18"

class
	EL_RSYNC_COMMAND_IMP

inherit
	EL_RSYNC_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			execute
		end

create
	make, make_backup, make_ssh_backup, make_default

feature -- Access

	Template: STRING = "[
		rsync $enabled_options
		#if $has_exclusions then
			--exclude-from=$exclusions_path
		#end
		#if $is_remote_destination then
			--rsh="$ssh.command"
			#if $make_remote_dir_enabled then
				--rsync-path="mkdir -p $ssh.user_domain:@remote ($destination_parent) && rsync"
			#end
			$source_path $ssh.user_domain:@remote ($destination_path)$trailing_slash
		#else
			$source_path $destination_path$trailing_slash
		#end
	]"

end
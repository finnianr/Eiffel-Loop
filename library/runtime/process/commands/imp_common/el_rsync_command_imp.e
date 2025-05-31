note
	description: "[
		Implementation of ${EL_RSYNC_COMMAND_I} with Unix [https://linux.die.net/man/1/rsync rsync command]
	]"
	notes: "[
		Example of rsync destination path:

			finnian@example.com:"'/home/finnian/.config/Hex 11 Software'/"

		The single quotes are required because of the spaces in path.
		The double quotes are necessary otherwise it creates remote path `/home/finnian/.config/Hex'.

		The value of `$trailing_slash' is '/' for file copying, and for directory copying
		it is just a space which is ignored.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-30 7:07:23 GMT (Friday 30th May 2025)"
	revision: "22"

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
				--rsync-path="mkdir -p @remote ($destination_parent) && rsync"
			#end
			$source_path $ssh.user_domain:"@remote ($destination_path)$trailing_slash"
		#else
			$source_path $destination_path$trailing_slash
		#end
	]"
end
note
	description: "[
		Implementation of ${EL_MD5_HASH_COMMAND_I} with Unix [https://linux.die.net/man/1/md5sum md5sum command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 9:34:39 GMT (Thursday 27th March 2025)"
	revision: "2"

class
	EL_MD5_HASH_COMMAND_IMP

inherit
	EL_MD5_HASH_COMMAND_I

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			getter_function_table, make_default
		end

create
	make, make_default

feature -- Access

	Template: STRING = "[
		#if $is_remote_destination then
			$ssh.command $ssh.user_domain "md5sum @remote ($target_path)"
		#else
			md5sum --$mode $target_path
		#end
	]"

end
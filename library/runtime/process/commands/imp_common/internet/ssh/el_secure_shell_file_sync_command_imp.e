note
	description: "Common implementation of [$source EL_SECURE_SHELL_FILE_SYNC_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-25 14:34:24 GMT (Wednesday 25th August 2021)"
	revision: "1"

class
	EL_SECURE_SHELL_FILE_SYNC_COMMAND_IMP

inherit
	EL_SECURE_SHELL_FILE_SYNC_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature -- Access

	Template: STRING = "[
		rsync -avz --delete 
		#if $progress_enabled then
			--progress
		#end
		#across $exclude_list as $list loop
			--exclude '$list.item'
		#end
		-e ssh $source_path $user_domain:$destination_path
	]"

end
note
	description: "Unix implementation of [$source EL_MOVE_FILE_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MOVE_FILE_COMMAND_IMP

inherit
	EL_MOVE_FILE_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		mv
		#if $is_file_destination then
			--no-target-directory
		#end
	 	$source_path $destination_path
	]"
	
end

note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-16 10:04:31 GMT (Wednesday 16th September 2015)"
	revision: "4"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

	EL_MODULE_DIRECTORY

create
	make

feature -- Access

	Template: STRING =
		--
	"[
		dir /B
		
		#if $is_recursive then
		/S
		#end
		
		/AD $path
	]"

feature -- Basic operations

	prepend_lines (command: EL_FIND_DIRECTORIES_COMMAND; output: PLAIN_TEXT_FILE)
			-- Prepend lines to output file before command has executed
			-- This is to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			output.put_string (command.dir_path.to_string)
			output.put_new_line
		end

end

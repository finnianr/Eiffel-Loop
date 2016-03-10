note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

	EL_MODULE_DIRECTORY

feature -- Access

	template: STRING =
		--
	"[
		dir /B
		
		#if $is_recursive then
		/S
		#end
		
		/AD "$path"
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

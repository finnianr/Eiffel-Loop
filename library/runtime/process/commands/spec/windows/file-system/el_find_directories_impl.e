note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 11:43:13 GMT (Friday 24th January 2014)"
	revision: "2"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

	EL_MODULE_DIRECTORY

create
	make

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

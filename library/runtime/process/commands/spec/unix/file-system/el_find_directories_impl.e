note
	description: "Summary description for {EL_FIND_DIRECTORIES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 10:28:10 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

create
	default_create

feature -- Access

	template: STRING = "[
		find "$path"
		#if $follow_symbolic_links then
			-L
		#end

		#if not $is_recursive then
			-maxdepth 1
		#end

		-type d
	]"

feature -- Not applicable

	prepend_lines (command: EL_FIND_DIRECTORIES_COMMAND; output: PLAIN_TEXT_FILE)
			-- Prepend lines to output file before command has executed
			-- This is to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			-- Do nothing under Unix
		end

end

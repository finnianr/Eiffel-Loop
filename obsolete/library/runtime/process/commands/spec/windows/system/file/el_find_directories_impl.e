note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-15 17:14:04 GMT (Wednesday 15th June 2016)"
	revision: "1"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL
		redefine
			new_output_lines
		end

	EL_MODULE_DIRECTORY

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

feature -- Factory

	new_output_lines: EL_ZSTRING_LIST
		do
			Result := Precursor
			Result.put_front (interface.dir_path.to_string)
		end

end
note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-11 14:09:07 GMT (Wednesday 11th May 2016)"
	revision: "3"

class
	EL_FIND_FILES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

feature -- Access

	template: STRING =
		--
	"[
		dir /B

		#if $is_recursive then
			/S
		#end
		
		/A-D $file_pattern_path
	]"

end
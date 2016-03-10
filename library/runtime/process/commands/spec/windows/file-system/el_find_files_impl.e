note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
		
		/A-D "$path\$file_pattern"
	]"

end

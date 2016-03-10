note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 10:28:03 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_FIND_FILES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

create
	default_create

feature -- Access

	template: STRING = "[
		find 
		#if $follow_symbolic_links then
			-L
		#end
		
		"$path"

		#if not $is_recursive then
			-maxdepth 1
		#end
		
	 	-type f -name "$file_pattern"
	]"

end

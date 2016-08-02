note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:40:28 GMT (Monday 16th May 2016)"
	revision: "1"

class
	EL_FIND_FILES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

feature -- Access

	template: STRING = "[
		find 
		#if $follow_symbolic_links then
			-L
		#end
		$path
		#if not $is_recursive then
			-maxdepth 1
		#end
	 	-type f -name "$file_pattern"
	]"

end
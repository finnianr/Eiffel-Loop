note
	description: "Unix find template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-27 8:29:09 GMT (Tuesday 27th June 2023)"
	revision: "8"

class
	EL_UNIX_FIND_TEMPLATE

feature {NONE} -- Constants

	Template: STRING = "[
		find
		#if $follow_symbolic_links then
			-L
		#end
		$dir_path
		-mindepth $min_depth
		#if not $limitless_max_depth then
			-maxdepth $max_depth
		#end
		-type $type
		#if $use_name_pattern then
			-name "$name_pattern"
		#end
	]"

end
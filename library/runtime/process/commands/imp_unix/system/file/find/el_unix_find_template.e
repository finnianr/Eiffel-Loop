note
	description: "Unix find template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_UNIX_FIND_TEMPLATE

feature {NONE} -- Constants

	Template: STRING = "[
		find
		#if $follow_symbolic_links then
			-L
		#end
		$path
		-mindepth $min_depth
		#if not $limitless_max_depth then
			-maxdepth $max_depth
		#end
		-type $type
		#if not $name_pattern.is_empty then
			-name "$name_pattern"
		#end
	]"

end
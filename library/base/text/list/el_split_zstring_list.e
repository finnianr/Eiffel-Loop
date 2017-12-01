note
	description: "[
		List of [$source EL_ZSTRING] split parts delimited by `delimiter'
		
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 19:26:17 GMT (Monday 27th November 2017)"
	revision: "2"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		redefine
			make
		end

create
	make, make_empty, make_from_sub_list

feature {NONE} -- Initialization

	make (a_string: like string; delimiter: READABLE_STRING_GENERAL)
		do
			string := a_string
			area_v2 := a_string.split_intervals (delimiter).area
			create internal_item.make_empty
		end

feature {NONE} -- Constants

	Tuple: TUPLE [substring: ZSTRING]
		once
			create Result
			Result.substring := ""
		end
end

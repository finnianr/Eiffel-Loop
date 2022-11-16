note
	description: "[
		A virtual split-list of [$source IMMUTABLE_STRING_32] represented as an array of [$INTEGER_64]
		substring intervals.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_IMMUTABLE_STRING_32_SPLIT_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE_STRING_32]
		redefine
			item
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

feature -- Access

	item: IMMUTABLE_STRING_32
		-- current iteration split item
		local
			interval: INTEGER_64
		do
			if not off then
				interval := interval_item
				Result := target.shared_substring (lower_integer (interval), upper_integer (interval))
			end
		end

end
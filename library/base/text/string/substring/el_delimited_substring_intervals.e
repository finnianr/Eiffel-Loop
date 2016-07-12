note
	description: "Summary description for {EL_DELIMITED_SUBSTRINGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-19 11:06:42 GMT (Saturday 19th December 2015)"
	revision: "5"

class
	EL_DELIMITED_SUBSTRING_INTERVALS [S -> READABLE_STRING_GENERAL]

inherit
	EL_SUBSTRINGS [S]
		rename
			make as make_substrings
		end

create
	make

feature {NONE} -- Initialization

	make (a_string, delimiter: S)
			--
		local
			delimiter_substrings: EL_OCCURRENCE_SUBSTRINGS [S]
			last_interval: INTEGER_64
		do
			create delimiter_substrings.make (a_string, delimiter)
			make_substrings (a_string, delimiter_substrings.count + 1)

			last_interval := new_item (1, 0)

			if delimiter_substrings.is_empty then
				extend (1, a_string.count)
			else
				from delimiter_substrings.start until delimiter_substrings.after loop
					extend (upper_integer (last_interval) + 1, delimiter_substrings.item_lower - 1)
					last_interval := delimiter_substrings.item
					delimiter_substrings.forth
				end
				extend (upper_integer (last_interval)  + 1, a_string.count)
			end
		end

feature -- Access

	substrings: EL_ARRAYED_LIST [S]
			-- string delimited list
		do
			create Result.make (count)
			from start until after loop
				Result.extend (substring)
				forth
			end
		end

end

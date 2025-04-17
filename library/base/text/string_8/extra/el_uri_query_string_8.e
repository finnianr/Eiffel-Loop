note
	description: "URI query (or fragment) string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 17:32:22 GMT (Wednesday 16th April 2025)"
	revision: "16"

class
	EL_URI_QUERY_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			is_reserved
		end

create
	make_encoded, make_empty, make, make_from_general

convert
	make_encoded ({STRING})

feature -- Element change

	append_query_string_32 (query_string: STRING_32)
		require
			balance_equals_and_ampersand: query_string.occurrences ('=') = query_string.occurrences ('&') + 1
		local
			value_list: EL_SPLIT_ON_CHARACTER_32 [STRING_32]; pair: STRING_32
			index_equal: INTEGER; not_first: BOOLEAN
		do
			create value_list.make (query_string, '&')
			across value_list as list loop
				if not_first then
					append_character ('&')
				else
					not_first := True
				end
				pair := list.item
				index_equal := pair.index_of ('=', 1)
				if index_equal > 0 then
					append_substring_general (pair, 1, index_equal - 1)
					append_character ('=')
					append_substring_general (pair, index_equal + 1, pair.count)
				end
			end
		end

feature {NONE} -- Implementation

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			Result := is_allowed_in_query (c)
		end

end
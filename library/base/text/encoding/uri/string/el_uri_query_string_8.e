note
	description: "URI query (or fragment) string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-12 9:36:16 GMT (Sunday 12th September 2021)"
	revision: "10"

class
	EL_URI_QUERY_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			is_reserved
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature -- Element change

	append_query_string_32 (query_string: STRING_32)
		require
			balance_equals_and_ampersand: query_string.occurrences ('=') = query_string.occurrences ('&') + 1
		local
			value_list: EL_SPLIT_STRING_32_LIST; pair: STRING_32
			index_equal: INTEGER
		do
			create value_list.make_with_character (query_string, '&')
			from value_list.start until value_list.after loop
				if value_list.index > 1 then
					append_character ('&')
				end
				pair := value_list.item (False)
				index_equal := pair.index_of ('=', 1)
				if index_equal > 0 then
					append_substring_general (pair, 1, index_equal - 1)
					append_character ('=')
					append_substring_general (pair, index_equal + 1, pair.count)
				end
				value_list.forth
			end
		end

feature {NONE} -- Implementation

	is_reserved (c: CHARACTER_32): BOOLEAN
		do
			Result := is_allowed_in_query (c)
		end

end
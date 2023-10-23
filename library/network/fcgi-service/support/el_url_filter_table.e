note
	description: "URL filters for hostile web-server traffic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-12 16:01:00 GMT (Thursday 12th October 2023)"
	revision: "1"

class
	EL_URL_FILTER_TABLE

inherit
	EL_GROUP_TABLE [ZSTRING, STRING]

	EL_MODULE_TUPLE

create
	make

feature -- Status report

	is_hacker_probe (path_lower: ZSTRING): BOOLEAN
		do
			if digit_count (path_lower) > Maximum_digits and then not path_lower.ends_with (Dot_png) then
				-- Block requests like: "GET /87543bde9176626b120898f9141058 HTTP/1.1"
				-- but allow: "GET /images/favicon/196x196.png HTTP/1.1"
				Result := True
			else
				Result := matches (path_lower)
			end
		end

feature {NONE} -- Implementation

	digit_count (path_lower: ZSTRING): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > path_lower.count loop
				if path_lower.is_numeric_item (i) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	matches (path_lower: ZSTRING): BOOLEAN
		-- `True' if `path_lower' matches one of the string predicates defined by `Predicate'
		do
			from start until after or Result loop
				Result := across item_for_iteration as string some
					matches_predicate (path_lower, string.item, key_for_iteration)
				end
				forth
			end
		end

	matches_predicate (path_lower, substring: ZSTRING; predicate_name: STRING): BOOLEAN
		do
			if predicate_name = Predicate.starts_with then
				Result := path_lower.starts_with (substring)

			elseif predicate_name = Predicate.ends_with then
				Result := path_lower.ends_with (substring)

			elseif predicate_name = Predicate.is_equal_ then
				Result := path_lower.is_equal (substring)

			elseif predicate_name = Predicate.has_substring then
				Result := path_lower.has_substring (substring)
			end
		end

feature -- Factory

	new_predicate_list: EL_STRING_8_LIST
		do
			create Result.make_from_tuple (Predicate)
		end

feature {NONE} -- Constants

	Dot_png: ZSTRING
		once
			Result := ".png"
		end

	Maximum_digits: INTEGER = 3
		-- maximum number of digits allowed in path

	Predicate: TUPLE [starts_with, has_substring, ends_with, is_equal_: STRING]
		once
			create Result
			Tuple.fill (Result, "starts_with, has_substring, ends_with, is_equal")
		end

end
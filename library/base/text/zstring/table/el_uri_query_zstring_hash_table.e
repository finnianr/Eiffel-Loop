note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 11:04:19 GMT (Tuesday 20th August 2024)"
	revision: "19"

class
	EL_URI_QUERY_ZSTRING_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [ZSTRING]

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make_equal, make_uri, make_url, make_default

feature -- Status query

	has_general (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			across String_scope as scope loop
				Result := has (scope.same_item (key))
			end
		end

	has_general_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		do
			across String_scope as scope loop
				Result := has_key (scope.same_item (key))
			end
		end

feature -- Access

	found_integer: INTEGER
		do
			if found then
				Result := found_item.to_integer
			end
		end

	found_natural: NATURAL
		do
			if found then
				Result := found_item.to_natural_32
			end
		end

	found_natural_8: NATURAL_8
		do
			if found then
				Result := found_item.to_natural_8
			end
		end

	found_string: ZSTRING
		do
			if found then
				Result := found_item
			else
				create Result.make_empty
			end
		end

	found_string_8: STRING
		do
			Result := found_string
		end

	integer_32_item (key: READABLE_STRING_GENERAL; default_value: INTEGER_32): INTEGER_32
		do
			if has_general_key (key) then
				 Result := found_integer
			else
				Result := default_value
			end
		end

	string_8_item (key: READABLE_STRING_GENERAL; default_string: STRING): STRING
		do
			if has_general_key (key) then
				 Result := found_string
			else
				Result := default_string
			end
		end

feature -- Cursor movement

	search_general (key: READABLE_STRING_GENERAL)
		do
			across String_scope as scope loop
				search (scope.same_item (key))
			end
		end

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end
end
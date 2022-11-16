note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "17"

class
	EL_URI_QUERY_ZSTRING_HASH_TABLE

inherit
	EL_URI_QUERY_HASH_TABLE [ZSTRING]

create
	make_equal, make_uri, make_url, make_default

convert
	found_string: {ZSTRING}, found_string_8: {STRING_8},
	found_integer: {INTEGER},
	found_natural: {NATURAL}, found_natural_8: {NATURAL_8}

feature -- Access

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

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): ZSTRING
		do
			Result := url.decoded
		end
end
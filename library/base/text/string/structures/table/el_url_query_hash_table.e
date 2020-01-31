note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 14:14:19 GMT (Friday 31st January 2020)"
	revision: "12"

class
	EL_URL_QUERY_HASH_TABLE

inherit
	EL_URL_QUERY_TABLE
		rename
			make_count as make_equal
		undefine
			is_equal, copy, default_create
		end

	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			item as table_item,
			make as make_table
		export
			{NONE} table_item
		end

	EL_ZSTRING_CONSTANTS

create
	make_equal, make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make_equal (0)
		end

feature -- Access

	item (key: ZSTRING): ZSTRING
		do
			if attached {ZSTRING} table_item (key) as l_result then
				Result := l_result
			else
				create Result.make_empty
			end
		end

feature -- Element change

	set_numeric (key: ZSTRING; value: NUMERIC)
		do
			set_string_general (key, value.out)
		end

	set_string (key, value: ZSTRING)
		do
			force (value, key)
		end

	set_string_general (key: ZSTRING; uc_value: READABLE_STRING_GENERAL)
		do
			set_string (key, create {ZSTRING}.make_from_general (uc_value))
		end

	set_name_value (name, value: ZSTRING)
		do
			put (value, name)
		end

feature -- Conversion

	url_query_string: STRING
			-- utf-8 URL encoded name value pairs
		local
			sum_count: INTEGER
			url: like Once_url_string
		do
			url := Once_url_string
			url.wipe_out
			from start until after loop
				if not url.is_empty then
					url.append_character ('&')
				end
				url.append_general (key_for_iteration)
				url.append_character ('=')
				url.append_general (item_for_iteration)
				forth
			end
			create Result.make_from_string (url)
		end

end

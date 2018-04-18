note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-01 14:40:38 GMT (Sunday 1st April 2018)"
	revision: "8"

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

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy, default_create
		end

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
				Result := Empty_string
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
			str: like Once_url_string
		do
			str := Once_url_string
			from start until after loop
				sum_count := key_for_iteration.count + item_for_iteration.count + 2
				forth
			end
			create Result.make (sum_count)
			from start until after loop
				if not Result.is_empty then
					Result.append_character ('&')
				end
				str.set_from_string (key_for_iteration); Result.append (str)
				Result.append_character ('=')
				str.set_from_string (item_for_iteration); Result.append (str)
				forth
			end
		end

end

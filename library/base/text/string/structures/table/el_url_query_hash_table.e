note
	description: "Hash table of URL query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 10:44:08 GMT (Saturday 1st February 2020)"
	revision: "1"

deferred class
	EL_URL_QUERY_HASH_TABLE [S -> STRING_GENERAL create make end]

inherit
	EL_URL_QUERY_TABLE
		rename
			make_count as make_equal
		undefine
			is_equal, copy, default_create
		end

	HASH_TABLE [S, S]
		rename
			item as table_item,
			make as make_table
		export
			{NONE} table_item
		end

feature {NONE} -- Initialization

	make_default
		do
			make_equal (0)
		end

feature -- Access

	item (key: READABLE_STRING_GENERAL): like new_string
		do
			if attached {like new_string} table_item (from_general (key)) as l_result then
				Result := l_result
			else
				Result := new_string (0)
			end
		end

feature -- Element change

	set_name_value (name, value: like new_string)
		do
			put (value, name)
		end

	set_numeric (key: like new_string; value: NUMERIC)
		do
			set_string_general (key, value.out)
		end

	set_string (key, value: like new_string)
		do
			force (value, key)
		end

	set_string_general (key, a_value: READABLE_STRING_GENERAL)
		do
			set_string (from_general (key), from_general (a_value))
		end

feature -- Conversion

	url_query_string: STRING
			-- utf-8 URL encoded name value pairs
		local
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

feature {NONE} -- Implementation

	from_general (str: READABLE_STRING_GENERAL): like new_string
		do
			if attached {like new_string} str as l_result then
				Result := l_result
			else
				create Result.make (str.count)
				Result.append (str)
			end
		end

	new_string (n: INTEGER): S
		do
			create Result.make (n)
		end

feature {NONE} -- Constants

	Once_url_string: EL_URL_QUERY_STRING_8
		once
			create Result.make_empty
		end

end

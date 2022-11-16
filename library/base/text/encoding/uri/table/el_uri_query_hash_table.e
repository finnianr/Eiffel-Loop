note
	description: "Hash table of URI query string name-value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_URI_QUERY_HASH_TABLE [S -> STRING_GENERAL create make end]

inherit
	EL_URI_QUERY_TABLE
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

	url_query: STRING
		-- utf-8 URL encoded name value pairs
		do
			Result := query_string (True, True)
		end

	uri_query: STRING
		-- utf-8 URL encoded name value pairs
		do
			Result := query_string (False, True)
		end

	query_string (is_url: BOOLEAN; keep_ref: BOOLEAN): STRING
		-- utf-8 encoded name value pairs
		-- `keep_ref' must be true if you wish to keep the reference (forces a clone of shared EL_URL_QUERY_STRING_8)
		local
			uri: like Once_uri_string
		do
			uri := empty_query_string (is_url)
			across Current as table loop
				if not table.is_first then
					uri.append_character ('&')
				end
				uri.append_general (table.key)
				uri.append_character ('=')
				uri.append_general (table.item)
			end
			if keep_ref then
				create Result.make_from_string (uri)
			else
				Result := uri
			end
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

end
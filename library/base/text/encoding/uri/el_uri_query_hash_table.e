note
	description: "Abstract table of URI query string name-value pairs"
	descendants: "[
			EL_URI_QUERY_HASH_TABLE* [S -> ${STRING_GENERAL}, B -> ${EL_STRING_BUFFER} [S, ${READABLE_STRING_GENERAL}]]
				${EL_URI_QUERY_ZSTRING_HASH_TABLE}
				${EL_URI_QUERY_STRING_32_HASH_TABLE}
				${EL_URI_QUERY_STRING_8_HASH_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "12"

deferred class
	EL_URI_QUERY_HASH_TABLE [
		S -> STRING_GENERAL create make end,
		BUFFER -> EL_STRING_BUFFER [S, READABLE_STRING_GENERAL] create default_create end
	]

inherit
	EL_URI_QUERY_TABLE
		rename
			make_sized as make_equal
		undefine
			is_equal, copy, default_create
		end

	EL_HASH_TABLE [S, S]
		rename
			item as table_item
		export
			{NONE} table_item
		redefine
			make
		end

feature {NONE} -- Initialization

	make_default
		do
			default_create
		end

	make (n: INTEGER)
		do
			Precursor (n)
			create buffer
		end

feature -- Access

	item (a_key: READABLE_STRING_GENERAL): like table_item
		local
			key: S
		do
			key := buffer.to_same (a_key)
			if attached table_item (key) as l_item then
				Result := l_item
			else
				create Result.make (0)
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

	found_string: S
		do
			if found then
				Result := found_item
			else
				create Result.make (0)
			end
		end

	found_string_8: STRING
		do
			Result := found_string.as_string_8
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
				 Result := found_string.as_string_8
			else
				Result := default_string
			end
		end

feature -- Status query

	has_general (key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has (buffer.to_same (key))
		end

	has_general_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- Is there an item in the table with key `key'? Set `found_item' to the found item.
		do
			Result := has_key (buffer.to_same (key))
		end

feature -- Element change

	set_name_value (name, value: like table_item)
		do
			force (value, name)
		end

	set_numeric (key: like table_item; value: NUMERIC)
		do
			set_string_general (key, value.out)
		end

	set_string (key, value: like table_item)
		do
			force (value, key)
		end

	set_string_general (key, value: READABLE_STRING_GENERAL)
		do
			force (new_compatible (value), new_compatible (key))
		end

feature -- Conversion

	query_string (is_url: BOOLEAN; keep_ref: BOOLEAN): STRING
		-- utf-8 encoded name value pairs
		-- `keep_ref' must be true if you wish to keep the reference
		-- (forces a clone of shared EL_URL_QUERY_STRING_8)
		local
			uri: EL_URI_QUERY_STRING_8; factory: EL_URI_ROUTINES
		do
			uri := factory.new_uri_string (is_url)
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

	to_table_32: EL_HASH_TABLE [STRING_32, STRING_32]
		do
			create Result.make_equal (count)
			across Current as table loop
				Result.extend (table.item.to_string_32, table.key.to_string_32)
			end
		end

	uri_query: STRING
		-- utf-8 URL encoded name value pairs
		do
			Result := query_string (False, True)
		end

	url_query: STRING
		-- utf-8 URL encoded name value pairs
		do
			Result := query_string (True, True)
		end

feature -- Cursor movement

	search_general (key: READABLE_STRING_GENERAL)
		do
			search (buffer.to_same (key))
		end

feature {NONE} -- Implementation

	new_compatible (general: READABLE_STRING_GENERAL): like table_item
		do
			if attached {like table_item} general as str then
				Result := str
			else
				create Result.make (general.count)
				Result.append (general)
			end
		end

feature {NONE} -- Initialization

	buffer: BUFFER
end
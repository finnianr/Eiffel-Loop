note
	description: "HTTP name value pair table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-26 12:13:01 GMT (Friday 26th August 2016)"
	revision: "2"

class
	EL_HTTP_HASH_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			item as table_item
		export
			{NONE} table_item
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy, default_create
		end

create
	make_equal, make_from_url_query

feature {NONE} -- Initialization

	make_from_url_query (query: STRING)
		local
			list: EL_STRING_LIST [STRING]; name_value_pair: STRING
			name, value: like url_string; pos_equals: INTEGER
		do
			create list.make_with_separator (query, '&', False)
			make_equal (list.count)
			create name.make_empty; create value.make_empty
			across list as pair loop
				name_value_pair := pair.item
				pos_equals := name_value_pair.index_of ('=', 1)
				if pos_equals > 1 then
					name.set_encoded (name_value_pair, 1, pos_equals - 1)
					value.set_encoded (name_value_pair, pos_equals + 1, name_value_pair.count)
					put (value.to_string, name.to_string)
				end
			end
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

	set_string_general (key: ZSTRING; uc_value: READABLE_STRING_GENERAL)
		do
			set_string (key, create {ZSTRING}.make_from_unicode (uc_value))
		end

	set_string (key, value: ZSTRING)
		do
			force (value, key)
		end

feature -- Conversion

	url_query_string: STRING
			-- utf-8 URL encoded name value pairs
		local
			sum_count: INTEGER
			str: like url_string
		do
			str := url_string
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

feature {NONE} -- Constants

	Url_string: EL_URL_QUERY_STRING
		once
			create Result.make_empty
		end

end

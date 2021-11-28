note
	description: "Abstraction to set name value pairs decoded from URI query string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-28 14:38:48 GMT (Sunday 28th November 2021)"
	revision: "11"

deferred class
	EL_URI_QUERY_TABLE

feature {NONE} -- Initialization

	make_url (query: STRING)
		do
			make_query_table (query, True)
		end

	make_uri (query: STRING)
		do
			make_query_table (query, False)
		end

	make_query_table (query: STRING; is_url: BOOLEAN)
		-- call `set_name_value' for each decoded name-value pair found in `query' string
		local
			ampersand_split: EL_SPLIT_ON_CHARACTER [STRING]; name_value_pair: STRING
			name, value: EL_URI_QUERY_STRING_8; pos_equals: INTEGER
		do
			create ampersand_split.make (query, '&')
			make_count (query.occurrences ('&') + 1)
			name := empty_query_string (is_url); value := new_query_string (is_url)

			across ampersand_split as list loop
				name_value_pair := list.item
				pos_equals := name_value_pair.index_of ('=', 1)
				if pos_equals > 1 then
					name.set_encoded (name_value_pair, 1, pos_equals - 1)
					value.set_encoded (name_value_pair, pos_equals + 1, name_value_pair.count)
					set_name_value (decoded_string (name), decoded_string (value))
				end
			end
		end

	make_count (n: INTEGER)
		deferred
		end

	make_default
		deferred
		end

feature -- Element change

	set_name_value (key, value: like decoded_string)
		deferred
		end

feature {NONE} -- Implementation

	decoded_string (url: EL_URI_QUERY_STRING_8): READABLE_STRING_GENERAL
		deferred
		end

	new_query_string (is_url: BOOLEAN): EL_URI_QUERY_STRING_8
		do
			if is_url then
				create {EL_URL_QUERY_STRING_8} Result.make_empty
			else
				create Result.make_empty
			end
		end

	empty_query_string (is_url: BOOLEAN): EL_URI_QUERY_STRING_8
		do
			if is_url then
				Result := Once_url_string
			else
				Result := Once_uri_string
			end
			Result.wipe_out
		end

feature {NONE} -- Constants

	Ampersand: STRING = "&"

	Once_uri_string: EL_URI_QUERY_STRING_8
		once
			create Result.make_empty
		end

	Once_url_string: EL_URL_QUERY_STRING_8
		once
			create Result.make_empty
		end

end
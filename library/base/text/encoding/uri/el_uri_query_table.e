note
	description: "Abstraction to set name value pairs decoded from URI query string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-05 15:26:12 GMT (Tuesday 5th December 2023)"
	revision: "14"

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
			pair_split: EL_URI_QUERY_PAIRS_SPLIT
		do
			create pair_split.make (query, is_url)
			make_count (pair_split.count)
			pair_split.do_with_pairs (agent set_name_value_from_query)
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

	set_name_value_from_query (name, value: EL_URI_QUERY_STRING_8)
		do
			set_name_value (decoded_string (name), decoded_string (value))
		end
end
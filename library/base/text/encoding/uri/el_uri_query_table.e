note
	description: "Abstraction to set name value pairs decoded from URI query string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:07:57 GMT (Sunday 24th May 2020)"
	revision: "8"

deferred class
	EL_URI_QUERY_TABLE

feature {NONE} -- Initialization

	make (url_query: STRING)
		-- call `set_name_value' for each decoded name-value pair found in `url_query' string
		local
			list: EL_SPLIT_STRING_LIST [STRING]; name_value_pair: STRING
			name, value: EL_URI_QUERY_STRING_8; pos_equals: INTEGER
		do
			create list.make (url_query, Ampersand)
			make_count (list.count)
			create name.make_empty; create value.make_empty
			from list.start until list.after loop
				name_value_pair := list.item (False)
				pos_equals := name_value_pair.index_of ('=', 1)
				if pos_equals > 1 then
					name.set_encoded (name_value_pair, 1, pos_equals - 1)
					value.set_encoded (name_value_pair, pos_equals + 1, name_value_pair.count)
					set_name_value (decoded_string (name), decoded_string (value))
				end
				list.forth
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

feature {NONE} -- Constants

	Ampersand: STRING = "&"

end

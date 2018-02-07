note
	description: "Abstraction to set name value pairs decoded from URL query string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 17:49:05 GMT (Saturday 16th December 2017)"
	revision: "1"

deferred class
	EL_HTTP_TABLE

feature {NONE} -- Initialization

	make_count (n: INTEGER)
		deferred
		end

	make_default
		deferred
		end

	make (url_query: STRING)
		-- call `set_name_value' for each decoded name-value pair found in `url_query' string
		local
			list: EL_SPLIT_STRING_LIST [STRING]; name_value_pair: STRING
			name, value: like url_string; pos_equals: INTEGER
		do
			create list.make (url_query, Ampersand)
			make_count (list.count)
			create name.make_empty; create value.make_empty
			from list.start until list.after loop
				name_value_pair := list.item
				pos_equals := name_value_pair.index_of ('=', 1)
				if pos_equals > 1 then
					name.set_encoded (name_value_pair, 1, pos_equals - 1)
					value.set_encoded (name_value_pair, pos_equals + 1, name_value_pair.count)
					set_name_value (name.to_string, value.to_string)
				end
				list.forth
			end
		end

feature -- Element change

	set_name_value (key, value: ZSTRING)
		deferred
		end

feature {NONE} -- Constants

	Url_string: EL_URL_QUERY_STRING
		once
			create Result.make_empty
		end

	Ampersand: STRING = "&"

end

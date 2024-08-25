note
	description: "Parses string for name value pair using specified delimiter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 11:12:43 GMT (Sunday 25th August 2024)"
	revision: "13"

class
	EL_NAME_VALUE_PAIR [G -> STRING_GENERAL create make, make_empty end]

inherit
	EL_MAKEABLE
		rename
			make as make_empty
		end

create
	make, make_empty, make_pair

feature {NONE} -- Initialization

	make (str: G; delimiter: CHARACTER_32)
		do
			set_from_string (str, delimiter)
			if not attached name then
				make_empty
			end
		end

	make_empty
		do
			create name.make_empty; create value.make_empty
		end

	make_pair (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
		end

feature -- Access

	as_assignment: G
		do
			Result := joined ('=')
		end

	joined (separator: CHARACTER): G
		do
			create Result.make (name.count + value.count + 1)
			append_to (Result, separator)
		end

	name: G

	value: G

feature -- Status query

	is_eiffel_name: BOOLEAN
		-- is `name' an eiffel identifier
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := r.shared_cursor (name).is_eiffel
		end

feature -- Basic operations

	append_to (str: G; separator: CHARACTER)
		do
			str.append (name)
			str.append_code (separator.natural_32_code)
			str.append (value)
		end

feature -- Element change

	set_from_string (str: G; delimiter: CHARACTER_32)
		local
			index: INTEGER
		do
			index := str.index_of (delimiter, 1)
			if index > 0 then
				name := str.substring (1, index - 1)
				value := str.substring (index + 1, str.count)
				value.adjust
			else
				create name.make_empty
				create value.make_empty
			end
		end

	wipe_out
		do
			name.keep_head (0)
			value.keep_head (0)
		end

end
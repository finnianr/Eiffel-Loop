note
	description: "Parses string for name value pair using specified delimiter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-09 10:47:06 GMT (Thursday 9th April 2020)"
	revision: "7"

class
	EL_NAME_VALUE_PAIR [G -> STRING_GENERAL create make, make_empty end]

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
			end
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

feature -- Basic operations

	append_to (str: G; separator: CHARACTER)
		do
			str.append (name)
			str.append_code (separator.natural_32_code)
			str.append (value)
		end

end

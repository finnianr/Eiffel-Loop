note
	description: "Parses string for name value pair using specified delimiter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-20 9:11:02 GMT (Tuesday 20th September 2016)"
	revision: "1"

class
	EL_NAME_VALUE_PAIR [G -> STRING_GENERAL create make_empty end]

create
	make, make_empty

feature {NONE} -- Initialization

	make (str: G; delimiter: CHARACTER)
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

feature -- Element change

	set_from_string (str: G; delimiter: CHARACTER)
		local
			pos_colon: INTEGER
		do
			pos_colon := str.index_of (delimiter, 1)
			if pos_colon > 0 then
				name := str.substring (1, pos_colon - 1)
				value := str.substring (pos_colon + 1, str.count)
				value.left_adjust; value.right_adjust
			end
		end

feature -- Access

	name: G

	value: G

end

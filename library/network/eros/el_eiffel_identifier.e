note
	description: "Eiffel identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_EIFFEL_IDENTIFIER

inherit
	STRING
		redefine
			make_from_string
		end

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (s: READABLE_STRING_8)
			--
		require else
			not_empty: not s.is_empty
			first_character_is_alpha: s.item (1).is_alpha
			remaining_characters_alpha_numeric_or_underscore: s.count > 1 implies contains_only_alpha_numeric_or_underscore (s)
		do
			Precursor (s)
		end

feature -- Query

	contains_only_alpha_numeric_or_underscore (s: READABLE_STRING_8): BOOLEAN
			--
		local
			i: INTEGER
		do
			Result := true
			from i := 1 until i > s.count or not Result loop
				if not s.item (i).is_alpha_numeric and then s.item (i) /= '_' then
					Result := false
				end
				i := i + 1
			end
		end

end
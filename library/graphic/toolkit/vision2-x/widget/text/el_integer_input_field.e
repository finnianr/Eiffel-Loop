note
	description: "Integer input field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-05 19:51:21 GMT (Tuesday 5th February 2019)"
	revision: "1"

class
	EL_INTEGER_INPUT_FIELD

inherit
	EL_INPUT_FIELD [INTEGER]
		rename
			normalize as force_natural
		redefine
			force_natural
		end

create
	make

feature {NONE} -- Implementation

	force_natural
		-- remove anything in text that is not numeric and position caret
		local
			l_text: STRING_32; i, caret_pos: INTEGER
		do
			l_text := text
			if l_text.count > 0 and then not l_text.is_integer then
				from i := 1 until i > l_text.count loop
					if not (l_text @ i).is_digit then
						l_text.remove (i)
						caret_pos := i
					else
						i := i + 1
					end
				end
				set_text (l_text)
				if caret_pos > 0 then
					set_caret_position (caret_pos)
				end
			end
		end

	to_data (str: STRING_32): INTEGER
		do
			if not text.is_empty then
				Result := text.to_integer
			end
		end

	to_text (a_value: INTEGER): STRING
		do
			Result := a_value.out
		end

	is_convertible (a_text: STRING_32): BOOLEAN
		do
			Result := a_text.is_integer
		end

end

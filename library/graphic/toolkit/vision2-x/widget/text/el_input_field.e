note
	description: "Input field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-05 19:50:15 GMT (Tuesday 5th February 2019)"
	revision: "1"

deferred class
	EL_INPUT_FIELD [G]

inherit
	EL_TEXT_FIELD
		export
			{NONE} set_text, set_initial_text
		end

feature {NONE} -- Initialization

	make (a_on_change: like on_change)
		do
			default_create
			on_change := a_on_change
			change_actions.extend (agent on_text_change)
		end

feature -- Element change

	set_initial_value (a_value: G)
		do
			set_initial_text (to_text (a_value))
		end

	set_value (a_value: G)
		do
			set_text (to_text (a_value))
		end

feature {NONE} -- Imp6lementation

	force_numeric_text
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

	on_text_change
		do
			on_change (to_data (text))
		end

	to_data (str: STRING_32): G
		deferred
		end

	to_text (a_value: G): READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	on_change: PROCEDURE [G]

end

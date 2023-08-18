note
	description: "Allow user selection from list of strings"
	notes: "[
		If `escape_option' is specified, option 0 places cursor before start of list
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 15:52:12 GMT (Thursday 17th August 2023)"
	revision: "2"

class
	EL_USER_MENU_SELECT

inherit
	EL_USER_INPUT_VALUE [INTEGER]
		rename
			make as make_input
		redefine
			line_input
		end

	EL_MODULE_FORMAT

create
	make

feature {NONE} -- Initialization

	make (a_prompt: READABLE_STRING_GENERAL; a_option_list: like option_list)
		do
			option_list := a_option_list
			make_valid (a_prompt, "Invalid option number", agent a_option_list.valid_index)
		end

feature -- Basic operations

	select_index
		local
			index: INTEGER
		do
			index := value
			if escape_pressed or else not option_list.valid_index (index) then
				option_list.start
				if not option_list.off then
					option_list.back
				end
			else
				option_list.go_i_th (index)
			end
		end

feature {NONE} -- Implementation

	line_input: ZSTRING
		do
			lio.put_line (User_input.Esc_to_quit)
			lio.put_new_line
			across option_list as list loop
				lio.put_labeled_string (Format.padded_integer (list.cursor_index, 2), list.item)
				lio.put_new_line
			end
			lio.put_new_line
			Result := Precursor
		end

feature {NONE} -- Internal attributes

	option_list: LIST [READABLE_STRING_GENERAL]

end
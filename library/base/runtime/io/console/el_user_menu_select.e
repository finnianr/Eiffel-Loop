note
	description: "Allow user selection from list of strings"
	notes: "[
		If `escape_option' is specified, option 0 places cursor before start of list
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-25 14:30:05 GMT (Tuesday 25th April 2023)"
	revision: "1"

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

	make (
		a_prompt: READABLE_STRING_GENERAL; a_option_list: like option_list
		a_escape_option: like escape_option
	)
		do
			option_list := a_option_list; escape_option := a_escape_option
			make_valid (a_prompt, "Invalid option number", agent valid_option)
		end

feature -- Basic operations

	select_index
		local
			index: INTEGER
		do
			index := value
			if option_list.valid_index (index) then
				option_list.go_i_th (index)
			else
				option_list.start
				if not option_list.off then
					option_list.back
				end
			end
		end

feature {NONE} -- Implementation

	line_input: ZSTRING
		do
			if attached escape_option as str then
				lio.put_labeled_string (" 0", str)
				lio.put_new_line
			end
			across option_list as list loop
				lio.put_labeled_string (Format.padded_integer (list.cursor_index, 2), list.item)
				lio.put_new_line
			end
			lio.put_new_line
			Result := Precursor
		end

	valid_option (index: INTEGER): BOOLEAN
		do
			if attached escape_option then
				Result := index = 0 or else option_list.valid_index (index)
			else
				Result := option_list.valid_index (index)
			end
		end

feature {NONE} -- Internal attributes

	escape_option: detachable READABLE_STRING_GENERAL

	option_list: LIST [READABLE_STRING_GENERAL]

end
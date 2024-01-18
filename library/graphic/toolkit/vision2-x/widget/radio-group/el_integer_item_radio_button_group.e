note
	description: "Integer item radio button group displayed in ascending order of ${INTEGER_32} value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_INTEGER_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [INTEGER]
		rename
			less_than as integer_less_than,
			make as make_button_group
		redefine
			integer_less_than
		end

create
	make

feature {NONE} -- Initialization

	make (
		initial_value: INTEGER; value_list: ITERABLE [INTEGER]; a_suffix: like suffix
		a_value_change_action: like value_change_action
	)
		do
			suffix := a_suffix
			make_button_group (initial_value, value_list, a_value_change_action)
		end

feature -- Access

	suffix: ZSTRING
		-- display suffix

feature {NONE} -- Implementation

	displayed_value (value: INTEGER): ZSTRING
		do
			create Result.make (2)
			Result.append_integer (value)
			if not suffix.is_empty then
				Result.append_character (' ')
				Result.append (suffix)
			end
		end

	integer_less_than (a, b: EL_WIDGET_VALUE [INTEGER]): BOOLEAN
		do
			Result := a.value < b.value
		end

end
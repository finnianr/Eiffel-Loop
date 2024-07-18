note
	description: "Text field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 15:35:39 GMT (Thursday 18th July 2024)"
	revision: "10"

class
	EL_TEXT_FIELD

inherit
	EV_TEXT_FIELD
		undefine
			set_text
		redefine
			create_implementation, implementation
		end

	EL_UNDOABLE_TEXT_COMPONENT
		undefine
			copy, is_in_default_state
		redefine
			implementation
		end

create
	default_create

feature {EV_ANY, EV_ANY_I} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_TEXT_FIELD_IMP} implementation.make
		end

	has_word_wrapping: BOOLEAN
		do
		end

	line_number_from_position (i: INTEGER): INTEGER
		do
		end

	scroll_to_line (i: INTEGER)
		do
		end

feature {NONE} -- Internal attributes

	implementation: EL_TEXT_FIELD_I

end
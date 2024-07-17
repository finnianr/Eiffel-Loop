note
	description: "Text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-17 16:05:15 GMT (Wednesday 17th July 2024)"
	revision: "10"

class
	EL_TEXT

inherit
	EV_TEXT
		undefine
			set_text
		redefine
			create_implementation, implementation, paste
		end

	EL_UNDOABLE_TEXT_COMPONENT
		undefine
			copy, is_in_default_state, paste
		redefine
			implementation
		end

	EL_MODULE_LOG

create
	default_create

feature -- Access

	caret_line: TUPLE [full_text: ZSTRING; start_index, end_index: INTEGER]
		-- interval indices of substring-line in `full_text' that has the caret
		local
			i, start_index, end_index, position: INTEGER
			uc: CHARACTER_32; uc_str, l_text: ZSTRING
		do
			l_text := text
			start_index := 1; end_index := l_text.count
			position := caret_position

			log.put_integer_field ("caret", position)
			log.put_integer_field (" start_index", start_index)
			log.put_integer_field (" end_index", end_index)

			uc := l_text [position]
			if uc.is_alpha_numeric then
				create uc_str.make_filled (uc, 1)
			else
				uc_str := uc.code.out
			end
			log.put_labeled_string (" Character", uc_str)
			log.put_new_line

			from i := position - 1 until i < 1 or else l_text [i] = '%N' loop
				i := i - 1
			end
			start_index := i + 1
			from i := position until i > end_index or l_text [i] = '%N' loop
				i := i + 1
			end
			end_index := i - 1
			Result := [l_text, start_index, end_index]
		end

feature -- Basic operations

	paste (a_position: INTEGER)
			-- Insert text from `clipboard' at `a_position'.
			-- No effect if clipboard is empty.
		local
			old_caret_position: INTEGER
		do
			old_caret_position := caret_position
			implementation.paste (a_position)
			if old_caret_position = a_position then
				set_caret_position (old_caret_position)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_TEXT_IMP} implementation.make
		end
	implementation: EL_TEXT_I

end
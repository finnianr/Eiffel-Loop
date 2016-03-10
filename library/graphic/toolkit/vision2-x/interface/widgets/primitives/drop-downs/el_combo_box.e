note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_COMBO_BOX

inherit
	EV_COMBO_BOX
		redefine
			set_strings, set_font
		end

	EL_MODULE_GUI
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, is_equal, copy
		end

create
	default_create, make_with_strings

feature -- Access

	selected_index: INTEGER
		do
			if selected then
				Result := index_of (selected_item, 1)
			end
		end

feature -- Basic operations

	adjust_width
		do
			set_minimum_width (GUI.widest_width (strings, font) + font.string_width ("M") * 3)
			is_width_adjusted := True
		end

feature -- Status query

	is_width_adjusted: BOOLEAN
		-- is width adjusted for the longest string

feature -- Status setting

	select_item (an_index: INTEGER)
			-- Select item at one based index, `an_index'.
		do
			implementation.select_item (an_index)
		end

	deselect_item (an_index: INTEGER)
			-- Deselect item at one based index, `an_index'.
		do
			implementation.deselect_item (an_index)
		end

	clear_selection
			-- Ensure there is no `selected_item' in `Current'.
		do
			implementation.clear_selection
		end

feature -- Element change

	set_font (a_font: EV_FONT)
		do
			Precursor (a_font)
			if is_width_adjusted then
				adjust_width
			end
		end

	set_strings (a_string_array: INDEXABLE [READABLE_STRING_GENERAL, INTEGER])
		local
			triple_o: STRING
		do
			Precursor (a_string_array)
			create triple_o.make_filled ('O', 3)
			set_minimum_width (GUI.widest_width (strings, font) + font.string_width (triple_o))
		end

feature -- Status query

	selected: BOOLEAN
			--
		do
			Result := implementation.selected_item /= Void
		end

end

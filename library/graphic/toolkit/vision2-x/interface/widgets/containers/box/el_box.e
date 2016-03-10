note
	description: "Summary description for {EL_EXPANDED_CELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

deferred class
	EL_BOX

inherit
	EV_BOX

	EL_MODULE_SCREEN
		undefine
			is_equal, default_create, copy
		end

feature {NONE} -- Initialization

	make (a_border_cms, a_padding_cms: REAL)
		do
			default_create
			set_spacing_cms (a_border_cms, a_padding_cms)
		end

--	framed (a_text: READABLE_STRING_GENERAL): EL_FRAME [like Current]
--		do
--			create Result.make_with_text_and_widget (a_text, Current)
--		end

feature -- Element change

	extend_unexpanded (v: like item)
			--
		do
			extend (v)
			disable_item_expand (v)
		end

	add_expanded_border (a_color: EV_COLOR)
			--
		do
			extend (create {EV_CELL})
			last.set_background_color (a_color)
		end

	add_fixed_border_cms (a_width_cms: REAL)
		do
			add_fixed_border (cms_to_pixels (a_width_cms))
		end

	add_fixed_border (a_pixels: INTEGER)
			--
		do
			add_expanded_border (background_color)
			disable_item_expand (last)
			set_last_size (a_pixels)
		end

	append_unexpanded (a_widgets: ARRAY [EV_WIDGET])
			--
		local
			i, upper: INTEGER
		do
 			upper := a_widgets.upper
			from i := a_widgets.lower until i > upper loop
				extend (a_widgets [i])
				if not attached {EL_EXPANDED_CELL} a_widgets [i] as cell then
					disable_item_expand (a_widgets [i])
				end
				i := i + 1
			end
		end

	append_array (a_widgets: ARRAY [EV_WIDGET])
			--
		do
 			a_widgets.do_all (agent extend)
		end

feature -- Status setting

	set_all_expansions (flag_array: ARRAY [BOOLEAN] )
			--
		require
			same_count: count = flag_array.count
		local
			i: INTEGER
		do
			from i := 1 until i > flag_array.count loop
				if flag_array [i] then
					enable_item_expand (i_th (i))
				else
					disable_item_expand (i_th (i))
				end
				i := i + 1
			end
		end

	expand_all
			--
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				enable_item_expand (i_th (i))
				i := i + 1
			end
		end

	set_spacing_cms (a_border_cms, a_padding_cms: REAL)
			--
		do
 			set_border_cms (a_border_cms); set_padding_cms (a_padding_cms)
		end

	set_padding_cms (a_padding_cms: REAL)
			--
		do
 			set_padding (cms_to_pixels (a_padding_cms))
		end

	set_border_cms (a_border_cms: REAL)
			--
		do
 			set_border_width (average_cms_to_pixels (a_border_cms))
		end

	set_minimum_width_cms (a_minimum_width_cms: REAL)
		do
			set_minimum_width (Screen.horizontal_pixels (a_minimum_width_cms))
		end

feature {NONE} -- Implementation

	set_last_size (size: INTEGER)
			--
		deferred
		end

	average_cms_to_pixels (cms: REAL): INTEGER
			-- centimeters to pixels conversion according to box orientation
		local
			l_screen: like Screen
		do
			l_screen := Screen
			Result := (l_screen.horizontal_pixels (cms) + l_screen.vertical_pixels (cms)) // 2
		end

	cms_to_pixels (cms: REAL): INTEGER
			-- centimeters to pixels conversion according to box orientation
		deferred
		end
end

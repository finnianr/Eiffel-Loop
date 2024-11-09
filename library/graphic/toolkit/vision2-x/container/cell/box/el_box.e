note
	description: "Box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-09 10:27:00 GMT (Saturday 9th November 2024)"
	revision: "16"

deferred class
	EL_BOX

inherit
	EV_BOX
		undefine
			Default_pixmaps
		end

	EL_MODULE_SCREEN

	EL_SHARED_DEFAULT_PIXMAPS

feature {NONE} -- Initialization

	make (a_border_cms, a_padding_cms: REAL)
		do
			default_create
			set_spacing_cms (a_border_cms, a_padding_cms)
		end

	make_centered (a_border_cms, a_padding_cms: REAL; widgets: ARRAY [EV_WIDGET])
		-- sandwich unexpanded `widgets' with two expanded cells
		do
			make (a_border_cms, a_padding_cms)
			replace_centered (widgets)
		end

	make_unexpanded (a_border_cms, a_padding_cms: REAL; widgets: ARRAY [EV_WIDGET])
		do
			make (a_border_cms, a_padding_cms)
			append_unexpanded (widgets)
		end

feature -- Element change

	add_expanded_border (a_color: EV_COLOR)
			--
		do
			extend (create {EV_CELL})
			last.set_background_color (a_color)
		end

	add_fixed_border (a_pixels: INTEGER)
			--
		do
			add_expanded_border (background_color)
			disable_item_expand (last)
			set_last_size (a_pixels)
		end

	add_fixed_border_cms (a_width_cms: REAL)
		do
			add_fixed_border (cms_to_pixels (a_width_cms))
		end

	append_array (a_widgets: ARRAY [EV_WIDGET])
			--
		do
			a_widgets.do_all (agent extend)
		end

	append_unexpanded (a_widgets: ARRAY [EV_WIDGET])
		--
		do
			across a_widgets as widget loop
				extend (widget.item)
				if not attached {EL_EXPANDABLE} widget.item then
					disable_item_expand (widget.item)
				end
			end
		end

	extend_unexpanded (v: like item)
			--
		do
			extend (v)
			disable_item_expand (v)
		end

	insert_unexpanded (v: like item; i: INTEGER)
			--
		do
			if valid_index (i) then
				go_i_th (i)
				put_left (v)
				disable_item_expand (v)
			end
		end

	prepend_unexpanded (v: like item)
			--
		do
			put_front (v)
			disable_item_expand (v)
		end

	replace_centered (a_widgets: ARRAY [EV_WIDGET])
		local
			l_widgets: ARRAYED_LIST [EV_WIDGET]
		do
			wipe_out
			create l_widgets.make_from_array (a_widgets)
			l_widgets.put_front (create {EL_EXPANDED_CELL})
			l_widgets.extend (create {EL_EXPANDED_CELL})
			append_unexpanded (l_widgets.to_array)
		end

	replace_items (old_widgets, new_widgets: ARRAY [EV_WIDGET])
		-- replace existing `old_widgets' with `new_widgets'
		require
			same_count: old_widgets.count = new_widgets.count
		local
			i: INTEGER; not_expanded: BOOLEAN
		do
			from i := 1 until i > old_widgets.count loop
				if attached old_widgets [i] as old_item then
					not_expanded := not is_item_expanded (old_item)

					start; search (old_item)
					if not after then
						replace (new_widgets [i])
						if not_expanded then
							disable_item_expand (new_widgets [i])
						end
					end
				end
				i := i + 1
			end
		end

feature -- Status setting

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

	set_all_expansions (flag_array: ARRAY [BOOLEAN] )
			--
		local
			l_cursor: like cursor
		do
			l_cursor := cursor
			from start until after loop
				if flag_array.valid_index (index) then
					set_item_expansion (flag_array [index])
				end
				forth
			end
			go_to (l_cursor)
		end

	set_border_cms (a_border_cms: REAL)
			--
		do
			set_border_width (average_cms_to_pixels (a_border_cms))
		end

	set_item_expansion (is_expanded: BOOLEAN)
		require
			item_selected: not off
		do
			if is_expanded then
				enable_item_expand (item)
			else
				disable_item_expand (item)
			end
		end

	set_minimum_width_cms (a_minimum_width_cms: REAL)
		do
			set_minimum_width (Screen.horizontal_pixels (a_minimum_width_cms))
		end

	set_padding_cms (a_padding_cms: REAL)
			--
		do
			set_padding (cms_to_pixels (a_padding_cms))
		end

	set_spacing_cms (a_border_cms, a_padding_cms: REAL)
			--
		do
			set_border_cms (a_border_cms); set_padding_cms (a_padding_cms)
		end

feature {NONE} -- Implementation

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

	set_last_size (size: INTEGER)
			--
		deferred
		end

end
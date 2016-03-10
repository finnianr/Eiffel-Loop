note
	description: "Summary description for {EL_SCROLLABLE_PAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_SCROLLABLE_PAGE

inherit
	EL_SCROLLABLE_BOX [EL_CENTERED_VERTICAL_BOX]
		rename
			make as make_scrollable,
			box as page
		redefine
			set_background_color, extend, extend_unexpanded, append_unexpanded, wipe_out
		end

create
	make

feature {NONE} -- Initialization

	make (a_page_border_cms, a_page_padding_cms, a_width_cms: REAL)
		do
			make_scrollable (a_page_border_cms, a_page_padding_cms)
			page.box.set_minimum_width_cms (a_width_cms)
		end

feature -- Element change

	set_background_color (a_color: like background_color)
		local
			page_background_color: like background_color
		do
			page_background_color := page.background_color
			Precursor (a_color)
			page.set_background_color (page_background_color)
			page.set_border_color (a_color)
		end

	set_page_color (a_color: like background_color)
		do
			page.set_background_color (a_color)
		end

	set_page_margin_cms (a_margin_cms: REAL)
		do
			page.set_horizontal_border_cms (a_margin_cms)
		end

	set_top_border_cms (a_height_cms: REAL)
		do
			page.set_top_border_cms (a_height_cms)
		end

	set_bottom_border_cms (a_height_cms: REAL)
		do
			page.set_bottom_border_cms (a_height_cms)
		end

	extend (v: like item)
		do
			page.extend (v)
		end

	extend_unexpanded (v: like item)
		do
			page.extend_unexpanded (v)
		end

	append_unexpanded (a_widgets: ARRAY [EV_WIDGET])
		do
			page.append_unexpanded (a_widgets)
		end

	wipe_out
		do
			page.box.wipe_out
		end

end

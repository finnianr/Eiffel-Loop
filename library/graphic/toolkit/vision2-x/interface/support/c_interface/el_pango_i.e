note
	description: "Pango i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_PANGO_I

inherit
	EL_POINTER_ROUTINES

feature -- Access

	pango_scale: INTEGER
		deferred
		end

	layout_indent (layout: POINTER): INTEGER
		require
			layout_attached: is_attached (layout)
		deferred
		end

	layout_pango_size (layout: POINTER): TUPLE [width, height: INTEGER]
			-- size scaled by PANGO_SCALE
		require
			layout_attached: is_attached (layout)
		deferred
		end

	layout_size (layout: POINTER): TUPLE [width, height: INTEGER]
		require
			layout_attached: is_attached (layout)
		deferred
		end

	layout_text (layout: POINTER): POINTER
		require
			layout_attached: is_attached (layout)
		deferred
		end

feature -- Factory

	new_font_description: POINTER
		deferred
		end

	new_font_description_from_string (str: POINTER): POINTER
		deferred
		end

feature -- Element change

	set_font_family (font_description: POINTER; a_family: POINTER)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_font_style (font_description: POINTER; a_pango_style: INTEGER_32)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_font_weight (font_description: POINTER; a_weight: INTEGER_32)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_font_stretch (font_description: POINTER; value: INTEGER)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_font_size (font_description: POINTER; a_size: INTEGER_32)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_font_absolute_size (font_description: POINTER; size: DOUBLE)
		require
			attached_font_description: is_attached (font_description)
		deferred
		end

	set_layout_text (a_layout: POINTER; a_text: POINTER; a_length: INTEGER_32)
		require
			layout_attached: is_attached (a_layout)
		deferred
		end

	set_layout_font_description (a_layout, a_font_desc: POINTER)
		require
			layout_attached: is_attached (a_layout)
		deferred
		end

	set_layout_width (a_layout: POINTER; a_width: INTEGER_32)
		require
			layout_attached: is_attached (a_layout)
		deferred
		end

feature -- Memory release

	font_description_free (font_description: POINTER)
		deferred
		end

end

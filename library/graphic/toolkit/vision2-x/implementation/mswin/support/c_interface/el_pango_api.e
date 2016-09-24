note
	description: "Summary description for {EL_PANGO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "1"

class
	EL_PANGO_API

inherit
	EL_DYNAMIC_MODULE [EL_PANGO_API_POINTERS]

	EL_PANGO_I
		undefine
			dispose
		end

	EL_PANGO_C_API
		undefine
			dispose
		end

create
	make

feature -- Access

	layout_indent (layout: POINTER): INTEGER
		do
			Result := pango_layout_get_indent (api.layout_get_indent, layout)
		end

	layout_pango_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_size (api.layout_get_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_pixel_size (api.layout_get_pixel_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_text (layout: POINTER): POINTER
		do
			Result := pango_layout_get_text (api.layout_get_text, layout)
		end

feature -- Factory

	new_font_description: POINTER
		do
			Result := pango_font_description_new (api.font_description_new)
		end

	new_font_description_from_string (str: POINTER): POINTER
		do
			Result := pango_font_description_from_string (api.font_description_from_string, str)
		end

feature -- Element change

	set_font_absolute_size (font_description: POINTER; size: DOUBLE)
		do
			pango_font_description_set_absolute_size (api.font_description_set_absolute_size, font_description, size)
		end

	set_font_family (a_font_description: POINTER; a_family: POINTER)
		do
			pango_font_description_set_family (api.font_description_set_family, a_font_description, a_family)
		end

	set_font_stretch (font_description: POINTER; value: INTEGER)
		do
			pango_font_description_set_stretch (api.font_description_set_stretch, font_description, value)
		end

	set_font_style (a_font_description: POINTER; a_style: INTEGER_32)
		do
			pango_font_description_set_style (api.font_description_set_style, a_font_description, a_style)
		end

	set_font_weight (a_font_description: POINTER; a_weight: INTEGER_32)
		do
			pango_font_description_set_weight (api.font_description_set_weight, a_font_description, a_weight)
		end

	set_font_size (a_font_description: POINTER; a_size: INTEGER_32)
		do
			pango_font_description_set_size (api.font_description_set_size, a_font_description, a_size)
		end

	set_layout_text (a_layout: POINTER; a_text: POINTER; a_length: INTEGER_32)
		do
			pango_layout_set_text (api.layout_set_text, a_layout, a_text, a_length)
		end

	set_layout_font_description (a_layout, a_font_description: POINTER)
		do
			pango_layout_set_font_description (api.layout_set_font_description, a_layout, a_font_description)
		end

	set_layout_width (a_layout: POINTER; a_width: INTEGER_32)
		do
			pango_layout_set_width (api.layout_set_width, a_layout, a_width)
		end

feature -- Memory release

	font_description_free (a_font_description: POINTER)
		do
			pango_font_description_free (api.font_description_free, a_font_description)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libpango-1.0-0"

	Name_prefix: STRING = "pango_"

end

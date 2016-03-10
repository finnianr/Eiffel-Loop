note
	description: "Summary description for {EL_PANGO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PANGO_API

inherit
	EL_DYNAMIC_MODULE

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
			Result := pango_layout_get_indent (pointer_layout_indent, layout)
		end

	layout_pango_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_size (pointer_layout_pango_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_pixel_size (pointer_layout_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_text (layout: POINTER): POINTER
		do
			Result := pango_layout_get_text (pointer_layout_text, layout)
		end

feature -- Factory

	new_font_description: POINTER
		do
			Result := pango_font_description_new (pointer_new_font_description)
		end

	new_font_description_from_string (str: POINTER): POINTER
		do
			Result := pango_font_description_from_string (pointer_new_font_description_from_string, str)
		end

feature -- Element change

	set_font_absolute_size (font_description: POINTER; size: DOUBLE)
		do
			pango_font_description_set_absolute_size (pointer_set_font_absolute_size, font_description, size)
		end

	set_font_family (a_font_description: POINTER; a_family: POINTER)
		do
			pango_font_description_set_family (pointer_set_font_family, a_font_description, a_family)
		end

	set_font_stretch (font_description: POINTER; value: INTEGER)
		do
			pango_font_description_set_stretch (pointer_set_font_stretch, font_description, value)
		end

	set_font_style (a_font_description: POINTER; a_style: INTEGER_32)
		do
			pango_font_description_set_style (pointer_set_font_style, a_font_description, a_style)
		end

	set_font_weight (a_font_description: POINTER; a_weight: INTEGER_32)
		do
			pango_font_description_set_weight (pointer_set_font_weight, a_font_description, a_weight)
		end

	set_font_size (a_font_description: POINTER; a_size: INTEGER_32)
		do
			pango_font_description_set_size (pointer_set_font_size, a_font_description, a_size)
		end

	set_layout_text (a_layout: POINTER; a_text: POINTER; a_length: INTEGER_32)
		do
			pango_layout_set_text (pointer_set_layout_text, a_layout, a_text, a_length)
		end

	set_layout_font_description (a_layout, a_font_description: POINTER)
		do
			pango_layout_set_font_description (pointer_set_layout_font_description, a_layout, a_font_description)
		end

	set_layout_width (a_layout: POINTER; a_width: INTEGER_32)
		do
			pango_layout_set_width (pointer_set_layout_width, a_layout, a_width)
		end

feature -- Memory release

	font_description_free (a_font_description: POINTER)
		do
			pango_font_description_free (pointer_font_description_free, a_font_description)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_layout_indent := 							function_pointer ("layout_get_indent")
			pointer_layout_size :=								function_pointer ("layout_get_pixel_size")
			pointer_layout_text :=								function_pointer ("layout_get_text")
			pointer_layout_pango_size :=						function_pointer ("layout_get_size")
			pointer_font_description_free := 				function_pointer ("font_description_free")
			pointer_new_font_description := 					function_pointer ("font_description_new")
			pointer_new_font_description_from_string := 	function_pointer ("font_description_from_string")
			pointer_set_layout_font_description := 		function_pointer ("layout_set_font_description")
			pointer_set_layout_text := 						function_pointer ("layout_set_text")
			pointer_set_layout_width := 						function_pointer ("layout_set_width")
			pointer_set_font_absolute_size := 				function_pointer ("font_description_set_absolute_size")
			pointer_set_font_family :=							function_pointer ("font_description_set_family")
			pointer_set_font_stretch :=						function_pointer ("font_description_set_stretch")
			pointer_set_font_style := 							function_pointer ("font_description_set_style")
			pointer_set_font_weight :=							function_pointer ("font_description_set_weight")
			pointer_set_font_size := 							function_pointer ("font_description_set_size")
		end

	pointer_layout_indent: POINTER

	pointer_layout_size: POINTER

	pointer_layout_text: POINTER

	pointer_layout_pango_size: POINTER

	pointer_new_font_description: POINTER

	pointer_new_font_description_from_string: POINTER

	pointer_set_layout_font_description: POINTER

	pointer_set_font_absolute_size: POINTER

	pointer_set_layout_text: POINTER

	pointer_set_layout_width: POINTER

	pointer_set_font_stretch: POINTER

	pointer_set_font_family: POINTER

	pointer_set_font_style: POINTER

	pointer_set_font_weight: POINTER

	pointer_set_font_size: POINTER

	pointer_font_description_free: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libpango-1.0-0"

	Name_prefix: STRING = "pango_"

end

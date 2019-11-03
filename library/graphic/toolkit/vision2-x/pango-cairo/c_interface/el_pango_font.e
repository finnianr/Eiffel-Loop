note
	description: "[
		Wrapper for PangoFontDescription convertable from class `EV_FONT'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 10:16:51 GMT (Saturday 26th October 2019)"
	revision: "7"

class
	EL_PANGO_FONT

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as item
		export
			{ANY} item
		end

	EL_SHARED_PANGO_API

	EV_FONT_CONSTANTS
		export
			{NONE} all
		end

	EL_PANGO_CAIRO_CONSTANTS
		export
			{NONE} all
			{ANY} Pango_stretch_values
		end

	EL_MODULE_UTF

	EL_SHARED_ONCE_STRING_8

create
	make, default_create

convert
	make ({EV_FONT})

feature {NONE} -- Initialization

	make (a_font: EV_FONT)
		local
			utf8_family_name: STRING
			c_name: ANY
		do
			make_from_pointer (Pango.new_font_description)

			utf8_family_name := empty_once_string_8
			UTF.string_32_into_utf_8_string_8 (a_font.name, utf8_family_name)
			c_name := utf8_family_name.to_c

			Pango.set_font_family (item, $c_name)
			Pango.set_font_style (item, pango_style (a_font.shape))
			Pango.set_font_weight (item, pango_weight (a_font.weight))
			set_stretch (Pango_stretch_normal)

			set_height (a_font.height_in_points * Pango.pango_scale)
		end

feature -- Access

	height: INTEGER
		-- height in pango units

feature -- Status change

	scale (factor: DOUBLE)
		do
			set_height ((height * factor).rounded)
		end

	set_stretch (value: INTEGER)
		require
			valid_value: Pango_stretch_values.has (value)
		do
			Pango.set_font_stretch (item, value)
		end

feature -- Element change

	set_height (a_height: INTEGER)
		do
			height := a_height
			Pango.set_font_size (item, height)
		end

feature {NONE} -- Implementation

	pango_weight (a_weight: INTEGER): INTEGER
		do
			inspect a_weight
				when Weight_thin then
					Result := Pango_weight_thin

				when Weight_regular then
					Result := Pango_weight_normal

				when Weight_bold then
					Result := Pango_weight_bold

				when Weight_black then
					Result := Pango_weight_heavy

			else
				Result := Pango_weight_normal
			end
		end

	pango_style (a_shape: INTEGER): INTEGER
		do
			if a_shape = Shape_italic then
				Result := Pango_style_italic
			else
				Result := Pango_style_normal
			end
		end

feature {NONE} -- Disposal

	c_free (this: POINTER)
			--
		do
			if not is_in_final_collect then
				Pango.font_description_free (this)
			end
		end

end

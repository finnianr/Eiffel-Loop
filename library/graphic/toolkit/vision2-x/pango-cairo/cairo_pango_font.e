note
	description: "[
		Wrapper for PangoFontDescription convertable from class ${EV_FONT}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 9:02:04 GMT (Monday 14th April 2025)"
	revision: "17"

class
	CAIRO_PANGO_FONT

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as item
		export
			{ANY} item
		end

	CAIRO_SHARED_PANGO_API

	CAIRO_PANGO_CONSTANTS
		export
			{NONE} all
			{ANY} is_valid_stretch
		end

	EV_FONT_CONSTANTS
		rename
			Weight_bold as EV_weight_bold,
			Weight_thin as EV_weight_thin
		export
			{NONE} all
			{ANY} valid_shape, valid_weight
		end

	EL_SHARED_UTF_8_STRING

create
	make, make_family, make_default

convert
	make ({EV_FONT})

feature {NONE} -- Initialization

	make (a_font: EV_FONT)
		do
			make_default
			set_family (a_font.name); set_shape (a_font.shape); set_weight (a_font.weight)
			set_stretch (Stretch_normal)
			set_height_by_points (a_font.height_in_points)
		end

	make_default
		do
			make_from_pointer (Pango.new_font_description)
		end

	make_family (a_name: READABLE_STRING_GENERAL)
		do
			make_default
			set_family (a_name)
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
			valid_value: is_valid_stretch (value)
		do
			Pango.set_font_stretch (item, value)
		end

feature -- Element change

	set_height (a_height: INTEGER)
		-- set height in pango units
		do
			height := a_height
			Pango.set_font_size (item, height)
		end

	set_family (a_name: READABLE_STRING_GENERAL)
		do
			if attached UTF_8_string as name then
				name.set_from_general (a_name)
				set_family_utf_8 (name)
			end
		end

	set_family_utf_8 (name_utf_8: STRING)
		require
			is_utf_8_encoded: valid_encoding (name_utf_8)
		local
			c_name: ANY; offset: INTEGER; sg: EL_STRING_GENERAL_ROUTINES
		do
			if sg.super_8 (name_utf_8).starts_with_character ('@') then
				offset := 1 -- @SimSun -> SimSun
			end
			c_name := name_utf_8.to_c
			Pango.set_font_family (item, $c_name + offset)
		end

	set_height_by_points (height_in_points: INTEGER)
		do
			set_height (height_in_points * Pango.pango_scale)
		end

	set_shape (ev_shape: INTEGER)
		require
			valid_shape: valid_shape (ev_shape)
		do
			Pango.set_font_style (item, pango_style (ev_shape))
		end

	set_weight (ev_weight: INTEGER)
		require
			valid_weight: valid_weight (ev_weight)
		do
			Pango.set_font_weight (item, pango_weight (ev_weight))
		end

feature {NONE} -- Implementation

	pango_weight (ev_weight: INTEGER): INTEGER
		do
			inspect ev_weight
				when {EV_FONT_CONSTANTS}.Weight_thin then
					Result := Weight_thin

				when {EV_FONT_CONSTANTS}.Weight_regular then
					Result := Weight_normal

				when {EV_FONT_CONSTANTS}.Weight_bold then
					Result := Weight_bold

				when {EV_FONT_CONSTANTS}.Weight_black then
					Result := Weight_heavy

			else
				Result := Weight_normal
			end
		end

	pango_style (ev_shape: INTEGER): INTEGER
		do
			if ev_shape = Shape_italic then
				Result := Style_italic
			else
				Result := Style_normal
			end
		end

feature -- Contract Support

	valid_encoding (utf_8: READABLE_STRING_8): BOOLEAN
		local
			c: EL_UTF_8_CONVERTER
		do
			Result := c.is_valid_string_8 (utf_8)
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
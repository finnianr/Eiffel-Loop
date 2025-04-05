note
	description: "Font"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 12:10:50 GMT (Saturday 5th April 2025)"
	revision: "17"

class
	EL_FONT

inherit
	EV_FONT
		redefine
			implementation, create_implementation, string_width
		end

	EL_MODULE_SCREEN

create
	default_create, make_regular, make_bold, make_with_values

feature {NONE} -- Initialization

	make_bold (a_family: READABLE_STRING_GENERAL; a_height_cms: REAL)
		do
			make_regular (a_family, a_height_cms)
			set_weight (Weight_bold)
		end

	make_regular (a_family: READABLE_STRING_GENERAL; a_height_cms: REAL)
		do
			default_create
			if not a_family.is_empty then
				preferred_families.extend (a_family.to_string_32)
			end
			set_height_cms (a_height_cms)
		end

	make_thin (a_family: READABLE_STRING_GENERAL; a_height_cms: REAL)
		do
			make_regular (a_family, a_height_cms)
			set_weight (Weight_thin)
		end

feature -- Measurement

	string_width (a_string: READABLE_STRING_GENERAL): INTEGER
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := implementation.string_width (r.to_unicode_general (a_string))
		end

	string_width_cms (str: ZSTRING): REAL
		do
			Result := string_width (str) / Screen.horizontal_resolution
		end

feature -- Element change

	set_height_cms (a_height_cms: REAL)
		do
			set_height (Screen.vertical_pixels (a_height_cms))
--			implementation.set_height_cms (a_height_cms)
		end

feature -- Conversion

	to_key: EL_FONT_KEY
		-- hashable key
		do
			create Result.make (Current)
		end

feature {NONE} -- Implementation

	create_implementation
			--
		do
			create {EL_FONT_IMP} implementation.make
		end

	implementation: EL_FONT_I

end
note
	description: "Font"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 12:03:00 GMT (Friday 21st December 2018)"
	revision: "8"

class
	EL_FONT

inherit
	EV_FONT
		redefine
			implementation, create_implementation, string_width
		end

	EL_MODULE_SCREEN
		undefine
			copy , default_create, is_equal
		end

	EL_MODULE_STRING_32
		undefine
			copy , default_create, is_equal
		end

create
	default_create, make_regular, make_bold, make_with_values

feature {NONE} -- Initialization

	make_regular (a_family: STRING; a_height_cms: REAL)
		do
			default_create
			if not a_family.is_empty then
				preferred_families.extend (a_family)
			end
			set_height_cms (a_height_cms)
		end

	make_bold (a_family: STRING; a_height_cms: REAL)
		do
			make_regular (a_family, a_height_cms)
			set_weight (Weight_bold)
		end

	make_thin (a_family: STRING; a_height_cms: REAL)
		do
			make_regular (a_family, a_height_cms)
			set_weight (Weight_thin)
		end

feature -- Measurement

	string_width_cms (str: ZSTRING): REAL
		do
			Result := string_width (str) / Screen.horizontal_resolution
		end

	string_width (a_string: READABLE_STRING_GENERAL): INTEGER
		do
			Result := Precursor (a_string.to_string_32)
		end

feature -- Element change

	set_height_cms (a_height_cms: REAL)
		do
			set_height (Screen.vertical_pixels (a_height_cms))
--			implementation.set_height_cms (a_height_cms)
		end

feature {NONE} -- Implementation

	implementation: EL_FONT_I

	create_implementation
			--
		do
			create {EL_FONT_IMP} implementation.make
		end

end

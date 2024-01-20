note
	description: "Hashable font key based on 5 characteristics"
	notes: "Useful for implementing a font cache such as ${EL_FONT_SET_CACHE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_FONT_KEY

inherit
	HASHABLE
		redefine
			is_equal, default_create
		end

	EV_FONT_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal, default_create
		end

create
	default_create, make

feature {NONE} -- Initialization

	default_create
		do
			create name.make_empty
		end

	make (a_font: EV_FONT)
		do
			set (a_font)
		end

feature -- Access

	hash_code: INTEGER
		do
			Result := height_18_bits | name_character_10_bits | family_3_bits | weight_2_bits | shape_1_bit
		end

	name: STRING_32

feature -- Element change

	set (a_font: EV_FONT)
		do
			set_family (a_font.family)
			set_height (a_font.height)
			set_name (a_font.name)
			set_shape (a_font.shape)
			set_weight (a_font.weight)
		end

	set_family (family: INTEGER)
		do
			family_3_bits := (family - Family_screen) |<< 3
		end

	set_height (height: INTEGER)
		do
			height_18_bits := height |<< 16
		end

	set_name (a_name: STRING_32)
		do
			name := a_name
			name_character_10_bits := (a_name.hash_code & 0x3FF) |<< 6
		end

	set_shape (shape: INTEGER)
		do
			shape_1_bit := shape - Shape_regular
		end

	set_weight (weight: INTEGER)
		do
			weight_2_bits := (weight - Weight_thin) |<< 1
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Does `other' have same appearance?
		do
			Result := hash_code = other.hash_code and then name ~ other.name
		end

feature {NONE} -- Internal attributes

	family_3_bits: INTEGER

	height_18_bits: INTEGER

	name_character_10_bits: INTEGER

	shape_1_bit: INTEGER
		-- bit 1

	weight_2_bits: INTEGER

end
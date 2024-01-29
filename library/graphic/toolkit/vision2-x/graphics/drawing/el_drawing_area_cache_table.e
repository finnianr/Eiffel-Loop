note
	description: "Cache table by combined width/height and identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-28 21:48:15 GMT (Sunday 28th January 2024)"
	revision: "1"

class
	EL_DRAWING_AREA_CACHE_TABLE

inherit
	EL_CACHE_TABLE [CAIRO_DRAWING_AREA, NATURAL]
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create drawing_area
		end

feature -- Element change

	set_drawing_area (a_drawing_area: like drawing_area)
		do
			drawing_area := a_drawing_area
		end

	dimension_item (a_width, a_height: INTEGER): CAIRO_DRAWING_AREA
		local
			id_shifted, width, height: NATURAL
		do
			width := a_width.to_natural_32.max (1); height := a_height.to_natural_32.max (1)
			id_shifted := drawing_area.id.to_natural_32 |<< 17
			if width >= height then
				Result := item (id_shifted | Is_width_mask | width)
			else
				Result := item (id_shifted | height)
			end
		end

feature {NONE} -- Implementation

	new_item (id_and_size_key: NATURAL): CAIRO_DRAWING_AREA
		-- bits 0 to 15 = width/height
		-- bit 16 = boolean is width dimension
		-- bit 17 to 31 = `drawing_area.id'
		local
			scaled_width, scaled_height: INTEGER
		do
			if (id_and_size_key & Is_width_mask).to_boolean then
				scaled_width := (id_and_size_key & Size_mask).to_integer_32
				if scaled_width = drawing_area.width then
					Result := drawing_area
				else
					create Result.make_scaled_to_width (drawing_area, scaled_width, Void)
				end
			else
				scaled_height := (id_and_size_key & Size_mask).to_integer_32
				if scaled_height = drawing_area.height then
					Result := drawing_area
				else
					create Result.make_scaled_to_height (drawing_area, scaled_height, Void)
				end
			end
		end

feature {NONE} -- Internal attributes

	drawing_area: CAIRO_DRAWING_AREA

feature {NONE} -- Constants

	Size_mask: NATURAL = 0xFFFF

	Is_width_mask: NATURAL = 0x10000

end
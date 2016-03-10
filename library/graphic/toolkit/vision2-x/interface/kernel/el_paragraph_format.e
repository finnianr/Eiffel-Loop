note
	description: "Summary description for {EL_PARAGRAPH_FORMAT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_PARAGRAPH_FORMAT

inherit
	EV_PARAGRAPH_FORMAT
		redefine
			copy, is_equal
		end

feature -- Duplication

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		do
			if implementation = Void then
				default_create
			end
			implementation.set_alignment (other.alignment)
			implementation.set_left_margin (other.left_margin)
			implementation.set_right_margin (other.right_margin)
			implementation.set_top_spacing (other.top_spacing)
			implementation.set_bottom_spacing (other.bottom_spacing)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := alignment = other.alignment
							and then left_margin = other.left_margin
							and then right_margin = other.right_margin
							and then top_spacing = other.top_spacing
							and then bottom_spacing = other.bottom_spacing

		end

end

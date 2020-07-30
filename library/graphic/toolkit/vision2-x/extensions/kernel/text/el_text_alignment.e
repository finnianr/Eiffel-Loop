note
	description: "Text alignment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-08 16:55:05 GMT (Wednesday 8th July 2020)"
	revision: "7"

class
	EL_TEXT_ALIGNMENT

inherit
	EV_TEXT_ALIGNMENT
		rename
			set_left_alignment as align_text_left,
			set_center_alignment as align_text_center,
			set_right_alignment as align_text_right
		export
			{EL_TEXT_ALIGNMENT} alignment_code
		end

feature -- Status query

	is_aligned_bottom: BOOLEAN
		do
			Result := vertical_alignment_code = Alignment_bottom
		end

	is_aligned_top: BOOLEAN
		do
			Result := vertical_alignment_code = Alignment_top
		end

	is_vertically_centered: BOOLEAN
		-- if true, text as a whole is vertically centered		
		do
			Result := vertical_alignment_code = Alignment_center
		end

feature -- Status setting

	align_text_bottom
			-- Display `text' vertically aligned at the bottom.
		do
			vertical_alignment_code := Alignment_bottom
		end

	align_text_top
			-- Display `text' vertically aligned at the top.
		do
			vertical_alignment_code := Alignment_top
		end

	align_text_vertical_center
			-- Display `text' vertically aligned at the center.
		do
			vertical_alignment_code := Alignment_center
		end

feature -- Contract Support

	is_valid_horizontal_alignment (code: INTEGER): BOOLEAN
		do
			inspect code
				when Left_alignment, Right_alignment, Center_alignment then
					Result := True
			else
			end
		end

	is_valid_vertical_alignment (code: INTEGER): BOOLEAN
		do
			inspect code
				when Alignment_bottom, Alignment_center, Alignment_top then
					Result := True
			else
			end
		end

feature {EL_TEXT_ALIGNMENT} -- Implementation

	vertical_alignment_code: INTEGER
		-- default is center

feature -- Element change

	copy_alignment (other: EL_TEXT_ALIGNMENT)
		do
			alignment_code := other.alignment_code
			vertical_alignment_code := other.vertical_alignment_code
		end

feature {NONE} -- Constants

	Alignment_bottom: INTEGER = 2

	Alignment_center: INTEGER = 0

	Alignment_top: INTEGER = 1

end

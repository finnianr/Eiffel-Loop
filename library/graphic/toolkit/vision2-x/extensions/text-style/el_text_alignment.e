note
	description: "Text alignment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 12:03:32 GMT (Friday 21st December 2018)"
	revision: "6"

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

	is_vertically_centered: BOOLEAN
		-- if true, text as a whole is vertically centered		
		do
			Result := vertical_alignment_code = Alignment_center
		end

	is_aligned_top: BOOLEAN
		do
			Result := vertical_alignment_code = Alignment_top
		end

	is_aligned_bottom: BOOLEAN
		do
			Result := vertical_alignment_code = Alignment_bottom
		end

feature -- Status setting

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

	align_text_bottom
			-- Display `text' vertically aligned at the bottom.
		do
			vertical_alignment_code := Alignment_bottom
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

	Alignment_center: INTEGER = 0

	Alignment_top: INTEGER = 1

	Alignment_bottom: INTEGER = 2

end
note
	description: "Font properties that can be combined into a [$source NATURAL_8] bitmap"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_FONT_PROPERTY

feature -- Font width

	Font_mask_width: NATURAL_8 = 3

	Font_monospace: NATURAL_8 = 1

	Font_proportional: NATURAL_8 = 2

feature -- Font type

	Font_mask_type: NATURAL_8 = 0xC
	
	Font_non_true_type: NATURAL_8 = 4

	Font_true_type: NATURAL_8 = 8

end

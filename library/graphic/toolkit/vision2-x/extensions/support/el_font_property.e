note
	description: "Font properties that can be combined into a ${NATURAL_8} bitmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_FONT_PROPERTY

feature -- Font width

	Font_any: NATURAL_8 = 0

	Font_mask_width: NATURAL_8 = 3

	Font_monospace: NATURAL_8 = 1

	Font_proportional: NATURAL_8 = 2

feature -- Font type

	Font_mask_type: NATURAL_8 = 0xC

	Font_non_true_type: NATURAL_8 = 4

	Font_true_type: NATURAL_8 = 8

end
note
	description: "Unix implemenation of interface [$source IL_STRING_SETTER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:06:24 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	TL_STRING_SETTER_IMP

inherit
	TL_STRING_SETTER_I
		redefine
			utf_16_area
		end

feature {NONE} -- Implementation

	extend (area: like utf_16_area; code: NATURAL)
		do
			area.extend (code)
		end

feature {NONE} -- Internal attributes

	utf_16_area: SPECIAL [NATURAL]
end

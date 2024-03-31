note
	description: "[
		Class to make descendants of abstract class ${EL_EXTENDABLE_AREA_I} createable.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 11:45:02 GMT (Sunday 31st March 2024)"
	revision: "73"

class
	EL_EXTENDABLE_AREA_IMP [G]

feature {NONE} -- Implementation

	set_area (a_area: like area)
		do
			area := a_area
		end

	new_filled_area (item: G; n: INTEGER): like area
		do
			create Result.make_filled (item, n)
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]

end
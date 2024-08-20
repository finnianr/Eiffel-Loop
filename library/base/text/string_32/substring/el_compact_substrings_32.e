note
	description: "[
		Creatable implementation of abstract class ${EL_COMPACT_SUBSTRINGS_32_I}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 11:42:12 GMT (Sunday 31st March 2024)"
	revision: "73"

class
	EL_COMPACT_SUBSTRINGS_32

inherit
	EL_COMPACT_SUBSTRINGS_32_I

	EL_EXTENDABLE_AREA_IMP [CHARACTER_32]
		export
			{EL_COMPACT_SUBSTRINGS_32_IMPLEMENTATION} area
		end

create
	make, make_from_other, make_joined, make_from_intervals

end
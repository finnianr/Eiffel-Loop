note
	description: "[
		Access of shared instances of ${EL_CHARACTER_32_AREA_ACCESS} and ${EL_CHARACTER_8_AREA_ACCESS}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 14:07:07 GMT (Sunday 20th April 2025)"
	revision: "1"

deferred class
	EL_SHARED_CHARACTER_AREA_ACCESS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Character_area_32: EL_CHARACTER_32_AREA_ACCESS
		once
			create Result.make_empty
		end

	Character_area_8: EL_CHARACTER_8_AREA_ACCESS
		once
			create Result.make_empty
		end

end
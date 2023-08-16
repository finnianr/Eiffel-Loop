note
	description: "Windows implementation of [$source EL_FONT_FAMILIES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:08 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I

feature {NONE} -- Implementation

	new_font_families: ARRAYED_LIST [STRING_32]
		do
			if attached implementation.application_i as app_imp
			--	On windows this is not a call to once function
				and then attached {ARRAYED_LIST [STRING_32]} app_imp.font_families as families
			then
				Result := families
			else
				create Result.make (0)
			end
		end

end
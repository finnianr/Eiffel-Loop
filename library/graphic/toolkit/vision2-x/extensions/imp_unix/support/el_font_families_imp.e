note
	description: "Unix implementation of [$source EL_FONT_FAMILIES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:48 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I

feature {NONE} -- Implementation

	new_font_families: ARRAYED_LIST [STRING_32]
		do
			if attached {EV_APPLICATION_IMP} implementation.application_i as app_imp then
				Result := app_imp.font_names_on_system
			else
				create Result.make (0)
			end
		end

end
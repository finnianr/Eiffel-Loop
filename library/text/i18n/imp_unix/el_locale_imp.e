note
	description: "Unix implementation of [$source EL_LOCALE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 17:35:42 GMT (Tuesday 22nd February 2022)"
	revision: "6"

class
	EL_LOCALE_IMP

inherit
	EL_LOCALE_I

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	user_language_code: STRING
			-- By example: if LANG = "en_UK.utf-8"
			-- then result = "en"
		local
			s: EL_STRING_32_ROUTINES
		do
			if attached Execution.item ("LANG") as lang then
				Result := s.substring_to (lang, '_', default_pointer)
			else
				Result := default_language
			end
		end

end
note
	description: "Summary description for {EL_LOCALE_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:34:56 GMT (Wednesday 24th June 2015)"
	revision: "3"

class
	EL_LOCALE_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make
	
feature -- Access

	user_language_code: STRING
			-- By example: if LANG = "en_UK.utf-8"
			-- then result = "en"
		do
			Result := Execution.get ("LANG").split ('_').first
		end

end

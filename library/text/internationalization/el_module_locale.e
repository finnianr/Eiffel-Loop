note
	description: "Summary description for {EL_LOCALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-06 15:05:49 GMT (Sunday 6th January 2013)"
	revision: "2"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature -- Access

	Locale: EL_LOCALE_ROUTINES
			--
		once ("PROCESS")
			create Result.make ("en")
		end

end

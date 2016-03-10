note
	description: "Summary description for {EL_LOCALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature -- Access

	Locale: EL_ENGLISH_DEFAULT_LOCALE_ROUTINES
			--
		once ("PROCESS")
			create Result.make
		end

end

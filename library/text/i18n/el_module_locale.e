note
	description: "Summary description for {EL_LOCALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:49:21 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature -- Access

	Locale: EL_DEFAULT_LOCALE_I
			--
		once ("PROCESS")
			create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make
		end

end
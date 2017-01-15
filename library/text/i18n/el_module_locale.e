note
	description: "Summary description for {EL_LOCALIZEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-13 13:15:28 GMT (Friday 13th January 2017)"
	revision: "2"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature -- Access

	Locale: EL_DEFAULT_LOCALE_I
			--
		once ("PROCESS")
			Result := new_default_locale
		end

feature {NONE} -- Factory

	new_default_locale: EL_DEFAULT_LOCALE_I
		do
			create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make
		end

end

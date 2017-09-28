note
	description: "[
		Localization implementation via once routine `Locale'. By calling the once routine `Locale'
		in the application before the once routine `{EL_MODULE_DEFERRED_LOCALE}.Locale',	
		any library classes that have deferred localization will now use `Locale'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-06 9:49:28 GMT (Sunday 6th August 2017)"
	revision: "4"

class
	EL_MODULE_LOCALE

inherit
	EL_MODULE_DEFERRED_LOCALE
		rename
			Locale as Deferred_locale
		redefine
			new_locale
		end

feature -- Access

	Locale: EL_DEFAULT_LOCALE_I
			--
		once ("PROCESS")
			Result := new_default_locale
		end

feature {NONE} -- Implementation

	new_locale: EL_DEFERRED_LOCALE_I
		do
			Result := Locale
		end

feature {NONE} -- Factory

	new_default_locale: EL_DEFAULT_LOCALE_I
		do
			create {EL_ENGLISH_DEFAULT_LOCALE_IMP} Result.make
		end

end

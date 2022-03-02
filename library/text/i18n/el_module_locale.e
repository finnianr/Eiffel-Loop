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
	date: "2022-03-02 8:48:12 GMT (Wednesday 2nd March 2022)"
	revision: "8"

deferred class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Locale: EL_DEFAULT_LOCALE
			--
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_DEFAULT_LOCALE]}
		end

end
note
	description: "[
		Localization implementation via once routine `Locale'. By calling the once routine `Locale'
		in the application before the once routine `{EL_MODULE_DEFERRED_LOCALE}.Locale',	
		any library classes that have deferred localization will now use `Locale'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "9"

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
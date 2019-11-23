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
	date: "2019-11-23 9:25:07 GMT (Saturday 23rd November 2019)"
	revision: "7"

deferred class
	EL_MODULE_LOCALE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Locale: EL_DEFAULT_LOCALE_I
			--
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_DEFAULT_LOCALE_I]}
		end

end

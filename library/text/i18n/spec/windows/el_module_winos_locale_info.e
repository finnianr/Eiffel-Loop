note
	description: "Summary description for {EL_MODULE_WINOS_LOCALE_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-06 9:15:31 GMT (Wednesday 6th April 2016)"
	revision: "4"

class
	EL_MODULE_WINOS_LOCALE_INFO

feature {NONE} -- Constants

	Win_os_locale_info: I18N_LOCALE_INFO
		local
			locale_imp: I18N_HOST_LOCALE_IMP
		once
			create locale_imp
			Result := locale_imp.create_locale_info_from_user_locale
		end

end
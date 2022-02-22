note
	description: "Partially initialized version of [$source I18N_NLS_LCID_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 16:57:45 GMT (Tuesday 22nd February 2022)"
	revision: "1"

class
	EL_I18N_ROUTINES

inherit
	I18N_NLS_GETLOCALEINFO

feature -- Access

	language: STRING
		do
			Result := extract_locale_string (user_locale, nls_constants.locale_siso639langname)
		end

feature {NONE} -- Implementation

	user_locale: INTEGER
			-- Encapsulation of GetUserDefaultLCID
		external
			"C (): LCID| <windows.h>"
		alias
			"GetUserDefaultLCID"
		end

end
note
	description: "Partially initialized version of [$source I18N_NLS_LCID_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 9:44:04 GMT (Sunday 7th January 2024)"
	revision: "3"

class
	EL_I18N_ROUTINES

inherit
	I18N_NLS_GETLOCALEINFO

	EL_WIN_32_C_API
		rename
			c_get_user_default_locale_id as user_locale
		end

feature -- Access

	language: STRING
		do
			Result := extract_locale_string (user_locale, nls_constants.locale_siso639langname)
		end

end
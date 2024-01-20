note
	description: "Partially initialized version of ${I18N_NLS_LCID_TOOLS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

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
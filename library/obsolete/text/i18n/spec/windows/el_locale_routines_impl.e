note
	description: "Summary description for {EL_LOCALE_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-16 10:26:30 GMT (Wednesday 16th September 2015)"
	revision: "1"

class
	EL_LOCALE_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	user_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		local
			locale: I18N_HOST_LOCALE_IMP; user_info: I18N_LOCALE_INFO
		do
			create locale
			user_info := locale.create_locale_info_from_user_locale
			Result := user_info.id.language_id.name
		end

end
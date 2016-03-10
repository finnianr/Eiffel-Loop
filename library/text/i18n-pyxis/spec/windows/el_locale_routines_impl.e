note
	description: "Summary description for {EL_LOCALE_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_LOCALE_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	user_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		local
			locale: I18N_HOST_LOCALE_IMP
			user_info: I18N_LOCALE_INFO
		do
			create locale
			user_info := locale.create_locale_info_from_user_locale
			Result := user_info.id.language_id.name
		end

end

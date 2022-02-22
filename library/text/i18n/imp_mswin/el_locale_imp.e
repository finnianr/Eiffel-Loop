note
	description: "Windows implementation of [$source EL_LOCALE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 16:48:00 GMT (Tuesday 22nd February 2022)"
	revision: "5"

class
	EL_LOCALE_IMP

inherit
	EL_LOCALE_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	user_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		local
			i18n: EL_I18N_ROUTINES
		do
			create i18n
			Result := i18n.language
		end

end
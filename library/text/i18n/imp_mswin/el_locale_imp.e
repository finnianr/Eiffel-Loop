note
	description: "Windows implementation of [$source EL_LOCALE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-27 16:33:25 GMT (Sunday 27th February 2022)"
	revision: "6"

class
	EL_LOCALE_IMP

inherit
	EL_LOCALE_I

	EL_OS_IMPLEMENTATION

	EL_MODULE_EXECUTABLE; EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Access

	user_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		local
			i18n: EL_I18N_ROUTINES
		do
			if Executable.Is_work_bench and then attached Execution_environment.item ("LANG") as lang then
				Result := lang
			else
				create i18n
				Result := i18n.language
			end
		end

end
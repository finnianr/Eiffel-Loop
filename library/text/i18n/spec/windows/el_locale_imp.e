note
	description: "Windows implementation of [$source EL_LOCALE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:31:47 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_LOCALE_IMP

inherit
	EL_LOCALE_I

	EL_MODULE_WINOS_LOCALE_INFO

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	user_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		do
			Result := Win_os_locale_info.id.language_id.name
		end

end

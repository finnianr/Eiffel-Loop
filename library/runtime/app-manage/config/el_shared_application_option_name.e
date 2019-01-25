note
	description: "Shared application option name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:03:09 GMT (Friday 25th January 2019)"
	revision: "1"

class
	EL_SHARED_APPLICATION_OPTION_NAME

feature {NONE} -- Implementation

	new_application_option_name: READABLE_STRING_GENERAL
		do
			Result := ""
		end

feature {NONE} -- Constants

	Application_option_name: ZSTRING
		once
			create Result.make_from_general (new_application_option_name)
		end
end

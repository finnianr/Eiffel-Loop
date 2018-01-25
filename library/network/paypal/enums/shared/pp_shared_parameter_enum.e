note
	description: "Summary description for {EL_SHARED_PAYPAL_VARIABLES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:44:24 GMT (Monday 18th December 2017)"
	revision: "5"

class
	PP_SHARED_PARAMETER_ENUM

feature {NONE} -- Constants

	Parameter: PP_PARAMETER_ENUM
		once
			create Result.make
		end

end

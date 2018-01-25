note
	description: "Summary description for {PP_PAYMENT_PAYMENT_STATUS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:18:11 GMT (Monday 18th December 2017)"
	revision: "2"

class
	PP_SHARED_PAYMENT_STATUS_ENUM

feature {NONE} -- Constants

	Payment_status_enum: PP_PAYMENT_STATUS_ENUM
		once
			create Result.make
		end

end

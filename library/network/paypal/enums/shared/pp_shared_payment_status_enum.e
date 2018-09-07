note
	description: "Pp shared payment status enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	PP_SHARED_PAYMENT_STATUS_ENUM

feature {NONE} -- Constants

	Payment_status_enum: PP_PAYMENT_STATUS_ENUM
		once
			create Result.make
		end

end
note
	description: "Summary description for {PP_SHARED_PAYMENT_PENDING_REASON_CODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-21 12:35:04 GMT (Thursday 21st December 2017)"
	revision: "2"

class
	PP_SHARED_PAYMENT_PENDING_REASON_ENUM

feature {NONE} -- Constants

	Pending_reason_enum: PP_PAYMENT_PENDING_REASON_ENUM
		once
			create Result.make
		end
end

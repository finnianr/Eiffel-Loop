note
	description: "Pp shared payment status enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	PP_SHARED_PAYMENT_STATUS_ENUM

inherit
	EL_ANY_SHARED
	
feature {NONE} -- Constants

	Payment_status_enum: PP_PAYMENT_STATUS_ENUM
		once
			create Result.make
		end

end
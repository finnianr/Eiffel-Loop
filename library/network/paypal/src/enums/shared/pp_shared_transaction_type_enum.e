note
	description: "Pp shared transaction type enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:58:42 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	PP_SHARED_TRANSACTION_TYPE_ENUM

inherit
	EL_ANY_SHARED
	
feature {NONE} -- Constants

	Transaction_type_enum: PP_TRANSACTION_TYPE_ENUM
		once
			create Result.make
		end
end

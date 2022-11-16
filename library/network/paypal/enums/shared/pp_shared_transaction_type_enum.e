note
	description: "Pp shared transaction type enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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
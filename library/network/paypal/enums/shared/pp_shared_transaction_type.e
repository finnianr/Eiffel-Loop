note
	description: "Summary description for {PP_SHARED_TRANSACTION_TYPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-20 8:01:24 GMT (Wednesday 20th December 2017)"
	revision: "1"

class
	PP_SHARED_TRANSACTION_TYPE

feature {NONE} -- Constants

	Transaction_type_enum: PP_TRANSACTION_TYPE_ENUM
		once
			create Result.make
		end
end

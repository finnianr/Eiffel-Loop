note
	description: "Summary description for {PP_SHARED_TRANSACTION_TYPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:28:20 GMT (Tuesday 24th April 2018)"
	revision: "2"

class
	PP_SHARED_TRANSACTION_TYPE_ENUM

feature {NONE} -- Constants

	Transaction_type_enum: PP_TRANSACTION_TYPE_ENUM
		once
			create Result.make
		end
end

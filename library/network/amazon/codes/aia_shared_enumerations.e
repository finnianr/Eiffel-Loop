note
	description: "Shared response codes and purchase reason codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:21:25 GMT (Monday 18th December 2017)"
	revision: "2"

class
	AIA_SHARED_ENUMERATIONS

feature {NONE} -- Constants

	Response_enum: AIA_RESPONSE_ENUM
		once
			create Result.make
		end

	Reason_enum: AIA_REASON_ENUM

		once
			create Result.make
		end
end

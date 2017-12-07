note
	description: "Shared response codes and purchase reason codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:00:22 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_SHARED_CODES

feature {NONE} -- Constants

	Response_code: AIA_RESPONSE_CODE
		once
			create Result.make
		end

	Reason_code: AIA_REASON_CODE

		once
			create Result.make
		end
end

note
	description: "Aia fail response"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-22 14:12:11 GMT (Wednesday 22nd January 2020)"
	revision: "1"

class
	AIA_FAIL_RESPONSE

inherit
	AIA_RESPONSE
		redefine
			Valid_responses
		end

create
	make

feature -- Constants

	Valid_responses: ARRAY [NATURAL_8]
		once
			Result := << response_enum.fail_other >>
		end

end

note
	description: "Aia fail response"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
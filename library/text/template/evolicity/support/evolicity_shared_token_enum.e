note
	description: "Shared instance of ${EVOLICITY_TOKEN_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EVOLICITY_SHARED_TOKEN_ENUM

feature {NONE} -- Keyword tokens

	Token: EVOLICITY_TOKEN_ENUM
		once ("PROCESS")
			create Result.make
		end
end
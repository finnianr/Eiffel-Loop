note
	description: "Shared instance of [$source EVOLICITY_TOKEN_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EVOLICITY_SHARED_TOKEN_ENUM

feature {NONE} -- Keyword tokens

	Token: EVOLICITY_TOKEN_ENUM
		once ("PROCESS")
			create Result.make
		end
end
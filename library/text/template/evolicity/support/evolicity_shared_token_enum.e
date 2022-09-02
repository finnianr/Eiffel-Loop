note
	description: "Shared instance of [$source EVOLICITY_TOKEN_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-01 16:08:50 GMT (Thursday 1st September 2022)"
	revision: "7"

class
	EVOLICITY_SHARED_TOKEN_ENUM

feature {NONE} -- Keyword tokens

	Token: EVOLICITY_TOKEN_ENUM
		once ("PROCESS")
			create Result.make
		end
end
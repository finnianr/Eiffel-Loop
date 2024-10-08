note
	description: "Shared instance of ${EL_UTF_8_STRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:01:44 GMT (Tuesday 20th August 2024)"
	revision: "3"

deferred class
	EL_SHARED_UTF_8_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	UTF_8_string: EL_UTF_8_STRING
		once
			create Result.make (0)
		end

end
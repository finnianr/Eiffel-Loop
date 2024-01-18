note
	description: "Shared instance of ${EL_UTF_8_STRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-22 9:42:54 GMT (Friday 22nd September 2023)"
	revision: "1"

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
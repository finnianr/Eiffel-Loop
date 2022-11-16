note
	description: "Shared instance of class [$source TL_STRING_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	TL_SHARED_ONCE_STRING_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Once_string_list: TL_STRING_LIST
		once
			create Result.make
		end

end
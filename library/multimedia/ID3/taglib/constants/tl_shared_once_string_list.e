note
	description: "Shared instance of class ${TL_STRING_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

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
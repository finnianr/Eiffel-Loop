note
	description: "Shared instance of class [$source TL_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-26 12:33:24 GMT (Thursday 26th March 2020)"
	revision: "3"

deferred class
	TL_SHARED_ONCE_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Once_string: TL_STRING
		once
			create Result.make_empty
		end

	Once_string_2: TL_STRING
		once
			create Result.make_empty
		end

end

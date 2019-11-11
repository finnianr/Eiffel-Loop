note
	description: "Shared instance of class [$source TL_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:20:06 GMT (Monday 11th November 2019)"
	revision: "1"

class
	TL_SHARED_ONCE_STRING

feature {NONE} -- Constants

	Once_string: TL_STRING
		once
			create Result.make_empty
		end

end

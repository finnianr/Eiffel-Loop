note
	description: "Shared instance of class [$source TL_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 12:12:46 GMT (Thursday 19th March 2020)"
	revision: "2"

deferred class
	TL_SHARED_ONCE_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Once_string: TL_STRING
		once
			create Result.make_empty
		end

end

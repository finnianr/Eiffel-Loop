note
	description: "Shared directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-25 10:51:15 GMT (Tuesday 25th February 2020)"
	revision: "8"

deferred class
	EL_SHARED_DIRECTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result.make_default
		end

end

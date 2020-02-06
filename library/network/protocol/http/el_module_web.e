note
	description: "Shared access to routines of class [$source EL_HTTP_CONNECTION]"
	notes: "[
		Using a shared web connection did not work well when tested, but maybe this
		problem will have been resolved with the changes of Sep 2016 to fix the underlying C API.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:27:34 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_WEB

inherit
	EL_MODULE

feature {NONE} -- Constants

	Web: EL_HTTP_CONNECTION
		once
			create Result.make
		end

end

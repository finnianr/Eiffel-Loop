note
	description: "Web connection"
	notes: "[
		Using a shared web connection did not work well when tested, but maybe this
		problem will have been resolved with the changes of Sep 2016 to fix the underlying C API.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:15:06 GMT (Monday 1st July 2019)"
	revision: "7"

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

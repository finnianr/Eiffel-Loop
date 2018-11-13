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
	date: "2018-11-12 18:11:11 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_WEB

feature {NONE} -- Constants

	Web: EL_HTTP_CONNECTION
		once
			create Result.make
		end

end

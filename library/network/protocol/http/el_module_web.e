note
	description: "Web connection"

	notes: "[
		Using a shared web connection did not work well when tested, but maybe this
		problem will have been resolved with the changes of Sep 2016 to fix the underlying C API.
	]"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-18 12:49:36 GMT (Sunday 18th September 2016)"
	revision: "2"

class
	EL_MODULE_WEB

feature -- Access

	Web: EL_HTTP_CONNECTION
		once
			create Result.make
		end

end

note
	description: "Shared access to instance of [$source CAIRO_GDK_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 13:46:32 GMT (Friday 31st July 2020)"
	revision: "8"

deferred class
	CAIRO_SHARED_GDK_API

inherit
	EL_ANY_SHARED

feature -- Access

	CAIRO_GDK: CAIRO_GDK_API
		once
			create Result.make
		end
end

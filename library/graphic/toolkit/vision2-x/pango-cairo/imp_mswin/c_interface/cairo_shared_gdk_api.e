note
	description: "Shared gdk api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:35:23 GMT (Thursday 30th July 2020)"
	revision: "7"

deferred class
	CAIRO_SHARED_GDK_API

inherit
	EL_ANY_SHARED

feature -- Access

	CAIRO_GDK: GDK_API
		once
			create Result.make
		end
end

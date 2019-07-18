note
	description: "Shared gdk api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:03 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_GDK_API

inherit
	EL_ANY_SHARED

feature -- Access

	GDK: EL_GDK_API
		once
			create Result.make
		end
end

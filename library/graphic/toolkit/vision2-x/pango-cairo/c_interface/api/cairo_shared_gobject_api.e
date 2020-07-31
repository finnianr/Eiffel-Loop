note
	description: "Shared access to instance of class conforming to [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 13:10:32 GMT (Thursday 30th July 2020)"
	revision: "8"

deferred class
	CAIRO_SHARED_GOBJECT_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Gobject: CAIRO_GOBJECT_I
		once ("PROCESS")
			create {CAIRO_GOBJECT_IMP} Result.make
		end

end

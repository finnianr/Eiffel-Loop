note
	description: "Shared access to instance of class conforming to [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:07:50 GMT (Sunday 2nd August 2020)"
	revision: "9"

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

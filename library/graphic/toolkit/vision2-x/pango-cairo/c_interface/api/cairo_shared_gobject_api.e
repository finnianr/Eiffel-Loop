note
	description: "Shared gobject api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:39:59 GMT (Thursday 30th July 2020)"
	revision: "7"

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

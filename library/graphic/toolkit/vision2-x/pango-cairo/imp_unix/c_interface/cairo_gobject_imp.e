note
	description: "Unix implementation of [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:07:50 GMT (Sunday 2nd August 2020)"
	revision: "9"

class
	CAIRO_GOBJECT_IMP

inherit
	CAIRO_GOBJECT_I
		rename
			default_create as make
		end

	CAIRO_GTK2_API
		rename
			default_create as make
		end

	EL_OS_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

end

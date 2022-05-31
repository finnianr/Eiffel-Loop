note
	description: "Unix implementation of [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 16:33:49 GMT (Monday 30th May 2022)"
	revision: "10"

class
	CAIRO_GOBJECT_IMP

inherit
	CAIRO_GOBJECT_I
		rename
			default_create as make
		end

	GTK2
		rename
			default_create as make
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

end
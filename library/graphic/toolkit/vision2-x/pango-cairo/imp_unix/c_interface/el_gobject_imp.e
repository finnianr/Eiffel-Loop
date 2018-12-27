note
	description: "Gobject imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-13 17:31:01 GMT (Thursday 13th December 2018)"
	revision: "7"

class
	EL_GOBJECT_IMP

inherit
	EL_GOBJECT_I
		rename
			default_create as make
		end

	EL_GTK2_API
		rename
			default_create as make
		end

create
	make

end

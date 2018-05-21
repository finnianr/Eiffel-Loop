note
	description: "Gobject imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_GOBJECT_IMP

inherit
	EL_GOBJECT_I
		rename
			default_create as make
		end

	GTK2
		rename
			default_create as make
		end

create
	make

end

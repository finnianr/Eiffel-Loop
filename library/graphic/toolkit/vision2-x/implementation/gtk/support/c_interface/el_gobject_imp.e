note
	description: "Summary description for {EL_GOBJECT_API}."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 7:40:14 GMT (Tuesday 4th October 2016)"
	revision: "2"

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

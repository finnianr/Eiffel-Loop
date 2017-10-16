note
	description: "Summary description for {EL_GOBJECT_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

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

note
	description: "Summary description for {EL_GOBJECT_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_GOBJECT_API

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

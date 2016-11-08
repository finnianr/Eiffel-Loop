note
	description: "Summary description for {EL_SHARED_GTK_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 7:44:52 GMT (Tuesday 4th October 2016)"
	revision: "2"

class
	EL_SHARED_GOBJECT_API

feature {NONE} -- Implementation

	Gobject: EL_GOBJECT_I
		once ("PROCESS")
			create {EL_GOBJECT_IMP} Result.make
		end

end

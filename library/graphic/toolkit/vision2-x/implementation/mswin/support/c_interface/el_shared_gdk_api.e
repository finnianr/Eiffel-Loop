note
	description: "Summary description for {EL_SHARED_GDK_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_SHARED_GDK_API

feature -- Access

	GDK: EL_GDK_API
		once
			create Result.make
		end
end
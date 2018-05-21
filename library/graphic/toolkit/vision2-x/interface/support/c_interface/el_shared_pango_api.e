note
	description: "Shared pango api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_PANGO_API

feature {NONE} -- Implementation

	Pango: EL_PANGO_I
		once ("PROCESS")
			create {EL_PANGO_API} Result.make
		end

end

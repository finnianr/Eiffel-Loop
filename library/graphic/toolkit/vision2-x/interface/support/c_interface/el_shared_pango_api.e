note
	description: "Summary description for {EL_SHARED_PANGO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_SHARED_PANGO_API

feature {NONE} -- Implementation

	Pango: EL_PANGO_I
		once
			create {EL_PANGO_API} Result.make
		end

end

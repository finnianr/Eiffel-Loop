note
	description: "Shared Cairo api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-23 11:11:25 GMT (Thursday 23rd July 2020)"
	revision: "7"

deferred class
	EL_SHARED_CAIRO_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Cairo: EL_CAIRO_I
		once ("PROCESS")
			create {EL_CAIRO_API} Result.make
		end

end

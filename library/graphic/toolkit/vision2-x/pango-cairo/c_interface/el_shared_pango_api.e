note
	description: "Shared pango api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:24:57 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_PANGO_API

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Pango: EL_PANGO_I
		once ("PROCESS")
			create {EL_PANGO_API} Result.make
		end

end

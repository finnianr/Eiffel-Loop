note
	description: "Module digest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:54:17 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	EL_MODULE_DIGEST

inherit
	EL_MODULE

feature {NONE} -- Constants

	Digest: EL_DIGEST_ROUTINES
		once
			create Result
		end

end

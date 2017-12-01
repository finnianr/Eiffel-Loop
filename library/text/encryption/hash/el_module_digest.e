note
	description: "Summary description for {EL_MODULE_DIGEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-15 11:46:40 GMT (Wednesday 15th November 2017)"
	revision: "1"

class
	EL_MODULE_DIGEST

inherit
	EL_MODULE

feature {NONE} -- Constants

	Digest: EL_DIGEST_ROUTINES
		once
			create Result
		end

end

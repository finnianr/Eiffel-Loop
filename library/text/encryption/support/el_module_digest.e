note
	description: "Shared access to routines of class [$source EL_DIGEST_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-17 10:33:58 GMT (Sunday 17th December 2023)"
	revision: "7"

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
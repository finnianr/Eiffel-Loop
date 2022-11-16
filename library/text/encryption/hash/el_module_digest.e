note
	description: "Shared access to routines of class [$source EL_DIGEST_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
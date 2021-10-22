note
	description: "Shared instance of [$source EL_INSTALL_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-22 12:34:30 GMT (Friday 22nd October 2021)"
	revision: "1"

deferred class
	EL_SHARED_INSTALL_TEXTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text: EL_INSTALL_TEXTS
		once
			create Result.make
		end

end
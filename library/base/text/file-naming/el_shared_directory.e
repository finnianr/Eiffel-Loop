note
	description: "Shared directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 17:53:10 GMT (Tuesday 24th December 2019)"
	revision: "7"

deferred class
	EL_SHARED_DIRECTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result.make_default
		end

end

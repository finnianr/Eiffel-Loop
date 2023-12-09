note
	description: "Shared instance of [$source EL_FORMAT_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-09 9:16:41 GMT (Saturday 9th December 2023)"
	revision: "2"

deferred class
	EL_SHARED_FORMAT_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	frozen Format: EL_FORMAT_FACTORY
		once
			create Result.make
		end
end
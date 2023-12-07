note
	description: "Shared instance of [$source EL_FORMAT_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-07 14:25:06 GMT (Thursday 7th December 2023)"
	revision: "1"

deferred class
	EL_SHARED_FORMAT_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	frozen Format_factory: EL_FORMAT_FACTORY
		once
			create Result.make
		end
end
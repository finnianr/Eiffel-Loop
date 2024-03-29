note
	description: "Shared instance of [$source EL_REUSEABLE_STRINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_MODULE_REUSEABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Reuseable: EL_REUSEABLE_STRINGS
		once
			create Result.make
		end
end
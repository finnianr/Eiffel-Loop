note
	description: "Shared instance of [$source EL_REUSEABLE_STRINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:10:43 GMT (Tuesday 7th December 2021)"
	revision: "3"

deferred class
	EL_MODULE_REUSABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Reuseable: EL_REUSEABLE_STRINGS
		once
			create Result.make
		end
end
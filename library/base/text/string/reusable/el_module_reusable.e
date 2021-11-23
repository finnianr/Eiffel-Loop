note
	description: "Shared instance of [$source EL_REUSABLE_STRINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 11:49:54 GMT (Tuesday 23rd November 2021)"
	revision: "2"

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
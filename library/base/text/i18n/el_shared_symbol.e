note
	description: "Shared instance of class [$source EL_SYMBOL_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 10:38:32 GMT (Monday 11th December 2023)"
	revision: "1"

deferred class
	EL_SHARED_SYMBOL

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Word: EL_SYMBOL_TEXTS
		once
			create Result.make
		end
end
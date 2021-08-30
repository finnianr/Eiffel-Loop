note
	description: "Shared instance of class [$source EL_WORD_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-19 9:49:11 GMT (Saturday 19th September 2020)"
	revision: "1"

deferred class
	EL_SHARED_WORD

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Word: EL_WORD_TEXTS
		once
			create Result.make
		end
end
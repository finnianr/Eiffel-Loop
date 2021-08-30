note
	description: "Shared instance of class [$source EL_PHRASE_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-30 12:07:25 GMT (Monday 30th August 2021)"
	revision: "1"

deferred class
	EL_SHARED_PHRASE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Phrase: EL_PHRASE_TEXTS
		once
			create Result.make
		end
end
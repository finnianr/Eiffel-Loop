note
	description: "Shared instance of class ${EL_PHRASE_TEXTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
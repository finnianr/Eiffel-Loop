﻿note
	description: "Shared instance of [$source EL_TEST_TEXT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_SHARED_TEST_TEXT

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text: EL_TEST_TEXT
		once
			create Result
		end
end
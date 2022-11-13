note
	description: "[
		Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]
		using [$source STRING_32] source text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-12 9:34:46 GMT (Saturday 12th November 2022)"
	revision: "1"

class
	STRING_32_PATTERN_MATCH_TEST_SET

inherit
	PATTERN_MATCH_TEST_SET
		redefine
			prepare_source
		end

feature {NONE} -- Implementation

	prepare_source
		do
			create {STRING_32} source_text.make_empty
		end

end
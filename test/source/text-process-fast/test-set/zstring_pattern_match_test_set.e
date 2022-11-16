note
	description: "[
		Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]
		using [$source ZSTRING] source text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	ZSTRING_PATTERN_MATCH_TEST_SET

inherit
	PATTERN_MATCH_TEST_SET
		redefine
			prepare_source
		end

feature {NONE} -- Implementation

	prepare_source
		do
			create {ZSTRING} source_text.make_empty
		end

end
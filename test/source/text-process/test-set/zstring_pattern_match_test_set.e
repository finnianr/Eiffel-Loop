note
	description: "[
		Test routines in libary cluster [./library/text-process-fast.pattern_match.html Pattern-matching]
		using ${ZSTRING} source text.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

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
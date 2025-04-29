note
	description: "Test ${EL_DOC_TYPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 10:28:46 GMT (Tuesday 29th April 2025)"
	revision: "4"

class
	DOC_TYPE_TEST_SET

inherit
	EL_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_SHARED_DOCUMENT_TYPES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["document_type", agent test_document_type]
			>>)
		end

feature -- Test

	test_document_type
		-- DOC_TYPE_TEST_SET.test_document_type
		note
			testing: "[
				covers/{EL_DOC_TYPE}.import,
				covers/{EL_SHARED_DOCUMENT_TYPES}.document_type,
				covers/{EL_SHAREABLE_CACHE_TABLE}.shared_item,
				covers/{EL_REFLECTIVELY_SETTABLE}.comma_separated_values
			]"
		local
			type: EL_DOC_TYPE; html_type: EL_HTML_DOC_TYPE
		do
			type := document_type (Text_type.HTML, {EL_ENCODING_TYPE}.UTF_8)
			assert_same_string ("correct specification", type.specification, "text/html; charset=UTF-8")

			create html_type.make_from_file ("data/XML/Hexagrams.html")
			assert_same_string ("correct specification", html_type.specification, "text/html; charset=ISO-8859-1")
		end

end
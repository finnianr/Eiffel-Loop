note
	description: "XML escaper test set"
	notes: "[
		Test sets conforming to [$source EL_CRC_32_TESTABLE] (like this one) can only be run
		from a sub-application conforming to [$source EL_CRC_32_AUTOTEST_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-29 12:11:46 GMT (Thursday 29th June 2023)"
	revision: "21"

class
	MARKUP_ESCAPE_TEST_SET

inherit
	EL_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_MODULE_HTML

	EL_CRC_32_TESTABLE

	EL_SHARED_TEST_TEXT

	EL_SHARED_ESCAPE_TABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["html_entity_substitution", agent test_html_entity_substitution],
				["xml_escape",					  agent test_xml_escape]
			>>)
		end

feature -- Tests

	test_html_entity_substitution
		-- MARKUP_ESCAPE_TEST_SET.html_entity_substitution
		local
			markup: ZSTRING
		do
			markup := "cent: &cent; & yen: &yen; & copyright: &copy;"
			Html.unescape_character_entities (markup)
			assert_same_string (Void, markup, "cent: ¢ & yen: ¥ & copyright: ©")
		end

	test_xml_escape
		local
			escaper, escaper_plus: XML_ESCAPER [ZSTRING]
			escaper_32, escaper_plus_32: XML_ESCAPER [STRING_32]
		do
			create escaper.make; create escaper_plus.make_128_plus

			create escaper_32.make; create escaper_plus_32.make_128_plus

			do_test ("make", 3127459384, agent escape, [escaper])
			do_test ("make_128_plus", 4273345417, agent escape, [escaper_plus])

			do_test ("make", 1874711133, agent escape, [escaper_32])
			do_test ("make_128_plus", 4034299380, agent escape, [escaper_plus_32])
		end

feature {NONE} -- Implementation

	escape (escaper: XML_ESCAPER [STRING_GENERAL])
		local
			str_32: STRING_32; xml: ZSTRING
			root: EL_XML_DOC_CONTEXT; s: EL_STRING_32_ROUTINES
		do
			across Text.lines as string loop
				str_32 := string.item.twin
				inspect string.cursor_index
					when 5 then
						s.replace_character (str_32, '´', '%'')
					when 6 then
						s.replace_character (str_32, ' ', '&')
				else
				end
				if attached escaper.escaped (str_32, False) as escaped then
					xml := XML_template #$ [escaped]
					lio.put_line (escaped)
				end
				create root.make_from_string (xml.to_utf_8 (True))
				assert ("same string", str_32.is_equal (root.query ("/TEXT")))
			end
		end

feature {NONE} -- Constants

	XML_template: ZSTRING
		once
			Result := "[
				<?xml version="1.0" encoding="UTF-8"?>
				<TEXT>#</TEXT>
			]"
		end

end
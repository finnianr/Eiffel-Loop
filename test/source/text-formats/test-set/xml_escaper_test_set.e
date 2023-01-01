note
	description: "XML escaper test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 8:53:01 GMT (Sunday 1st January 2023)"
	revision: "16"

class
	XML_ESCAPER_TEST_SET

inherit
	EL_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("xml_escape", agent test_xml_escape)
		end

feature -- Tests

	test_xml_escape
		do
			do_test ("make", 855989182, agent escape, [create {XML_ZSTRING_ESCAPER}.make])
			do_test ("make_128_plus", 2055570232, agent escape, [create {XML_ZSTRING_ESCAPER}.make_128_plus])

			do_test ("make", 3958945292, agent escape, [create {XML_STRING_32_ESCAPER}.make])
			do_test ("make_128_plus", 3197404867, agent escape, [create {XML_STRING_32_ESCAPER}.make_128_plus])
		end

feature {NONE} -- Implementation

	escape (escaper: XML_GENERAL_ESCAPER)
		local
			str_32, esc_str_32: STRING_32; str, esc_str, xml: ZSTRING
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
				str := str_32

				if attached {XML_ZSTRING_ESCAPER} escaper as z_escaper then
					esc_str := z_escaper.escaped (str, False)
					xml := XML_template #$ [esc_str]
					lio.put_line (esc_str)
				else
					esc_str_32 := escaper.escaped (str_32, False)
					xml := XML_template #$ [esc_str_32]
					lio.put_line (esc_str_32)
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
note
	description: "XML escaper test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 13:00:38 GMT (Sunday 3rd January 2021)"
	revision: "3"

class
	XML_ESCAPER_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

	EL_TEST_STRINGS

	EL_MODULE_STRING_32

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("xml_escape", agent test_xml_escape)
		end

feature -- Tests

	test_xml_escape
		do
			do_test ("make", 3792568687, agent escape, [create {EL_XML_ZSTRING_ESCAPER}.make])
			do_test ("make_128_plus", 3518096339, agent escape, [create {EL_XML_ZSTRING_ESCAPER}.make_128_plus])

			do_test ("make", 4167379891, agent escape, [create {EL_XML_STRING_32_ESCAPER}.make])
			do_test ("make_128_plus", 1319921288, agent escape, [create {EL_XML_STRING_32_ESCAPER}.make_128_plus])
		end

feature {NONE} -- Implementation

	escape (escaper: EL_XML_GENERAL_ESCAPER)
		local
			str_32, esc_str_32: STRING_32; str, esc_str, xml: ZSTRING
			root: EL_XPATH_ROOT_NODE_CONTEXT
		do
			across Text_lines as string loop
				str_32 := string.item.twin
				inspect string.cursor_index
					when 5 then
						String_32.replace_character (str_32, '´', '%'')
					when 6 then
						String_32.replace_character (str_32, ' ', '&')
				else
				end
				str := str_32

				if attached {EL_XML_ZSTRING_ESCAPER} escaper as z_escaper then
					esc_str := z_escaper.escaped (str, False)
					xml := XML_template #$ [esc_str]
					log.put_line (esc_str)
				else
					esc_str_32 := escaper.escaped (str_32, False)
					xml := XML_template #$ [esc_str_32]
					log.put_line (esc_str_32)
				end
				create root.make_from_string (xml.to_utf_8)
				assert ("same string", str_32 ~ root.string_32_at_xpath ("/TEXT"))
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
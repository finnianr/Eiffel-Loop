note
	description: "Test class [$source EL_TEMPLATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-07 10:11:03 GMT (Saturday 7th September 2019)"
	revision: "1"

class
	TEMPLATE_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_basic
		local
			template: EL_TEMPLATE [ZSTRING]
			template_string, prefix_string: STRING
			s1, s2, one_two, one_one: ZSTRING
		do
			prefix_string := "--"; template_string := "${s1}, $s2"
			s1 := "one"; s2 := "two"; one_two := "one, two"; one_one := "one, one"

			across 1 |..| 2 as n loop
				if n.cursor_index = 2 then
					template_string.prepend (prefix_string)
					one_one.prepend_string_general (prefix_string)
					one_two.prepend_string_general (prefix_string)
				end
				create template.make (template_string)
				template.put ("s1", s1)
				template.put ("s2", s2)
				assert ("same string", template.substituted ~ one_two)
				template.put ("s2", s1)
				assert ("same string", template.substituted ~ one_one)
			end
		end

end

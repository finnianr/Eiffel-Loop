note
	description: "Test class [$source EL_TEMPLATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 11:00:19 GMT (Friday 14th February 2020)"
	revision: "3"

class
	TEMPLATE_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("basic",	agent test_basic)
			eval.call ("date",	agent test_date)
		end

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

	test_date
		local
			template: EL_TEMPLATE [ZSTRING]
		do
--			canonical: STRING = "$long_day_name $canonical_numeric_month $long_month_name $year"
			create template.make ({EL_DATE_FORMATS}.Canonical)
			template.put ("long_day_name", "Thursday")
			template.put ("canonical_numeric_month", "23rd")
			template.put ("long_month_name", "November")
			template.put ("year", "2017")
			assert ("same date", Date_string ~ template.substituted)
		end

feature {NONE} -- Constants

	Date_string: ZSTRING
		once
			Result := "Thursday 23rd November 2017"
		end

end

note
	description: "Test class [$source EL_TEMPLATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-09 13:44:39 GMT (Friday 9th June 2023)"
	revision: "11"

class
	TEMPLATE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_DATE_FORMAT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["basic", agent test_basic],
				["date", agent test_date],
				["name_separation", agent test_name_separation],
				["dollor_escaping", agent test_dollor_escaping],
				["repeated_variable", agent test_repeated_variable]
			>>)
		end

feature -- Tests

	test_basic
		note
			testing: "covers/{EL_TEMPLATE}.make", "covers/{EL_TEMPLATE}.substituted"
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
			create template.make (Date_format.Canonical)
			template.put (Date_format.Var.long_day_name, "Thursday")
			template.put (Date_format.Var.canonical_numeric_day, "23rd")
			template.put (Date_format.Var.long_month_name, "November")
			template.put (Date_format.Var.year, "2017")
			assert ("same date", Date_string ~ template.substituted)
		end

	test_dollor_escaping
		note
			testing: "covers/{EL_TEMPLATE}.make", "covers/{EL_TEMPLATE}.substituted"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s %%$ USD")
			template.put ("s", "one")
			assert ("same string", template.substituted ~ "one $ USD")
		end

	test_name_separation
		note
			testing: "covers/{EL_TEMPLATE}.make", "covers/{EL_TEMPLATE}.substituted"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s, $s_2")
			template.put ("s", "one")
			template.put ("s_2", "two")
			assert ("same string", template.substituted ~ "one, two")
		end

	test_repeated_variable
		note
			testing: "covers/{EL_TEMPLATE}.make", "covers/{EL_TEMPLATE}.substituted"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s $s $s")
			template.put ("s", "one")
			assert ("same string", template.substituted ~ "one one one")
		end

feature {NONE} -- Constants

	Date_string: ZSTRING
		once
			Result := "Thursday 23rd November 2017"
		end

end
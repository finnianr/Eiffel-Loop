note
	description: "Test class ${EL_TEMPLATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 8:25:39 GMT (Tuesday 22nd April 2025)"
	revision: "18"

class TEMPLATE_TEST_SET inherit BASE_EQA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_DATE_FORMAT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["basic",						 agent test_basic],
				["date",							 agent test_date],
				["dollor_escaping",			 agent test_dollor_escaping],
				["name_separation",			 agent test_name_separation],
				["repeated_variable",		 agent test_repeated_variable],
				["substituted_environment", agent test_substituted_environment]
			>>)
		end

feature -- Tests

	test_basic
		note
			testing: "[
				covers/{EL_TEMPLATE}.make,
				covers/{EL_TEMPLATE}.substituted
			]"
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
			testing: "[
				covers/{EL_TEMPLATE}.make,
				covers/{EL_TEMPLATE}.substituted
			]"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s %%$ USD")
			template.put ("s", "one")
			assert ("same string", template.substituted ~ "one $ USD")
		end

	test_name_separation
		-- TEMPLATE_TEST_SET.test_name_separation
		note
			testing: "[
				covers/{EL_TEMPLATE}.make,
				covers/{EL_TEMPLATE}.substituted
			]"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s, ${s_2}")
			template.put ("s", "one")
			assert ("same string", template.substituted ~ "one, ${s_2}")
			template.put ("s_2", "two")
			assert ("same string", template.substituted ~ "one, two")
			template.put ("s_2", "")
			assert ("same string", template.substituted ~ "one, ")
		end

	test_repeated_variable
		note
			testing: "[
				covers/{EL_TEMPLATE}.make, covers/{EL_TEMPLATE}.substituted
			]"
		local
			template: EL_TEMPLATE [STRING]
		do
			create template.make ("$s $s $s")
			template.put ("s", "one")
			assert ("same string", template.substituted ~ "one one one")
		end

	test_substituted_environment
		-- TEMPLATE_TEST_SET.test_substituted_environment
		note
			testing: "[
				covers/{EL_TEMPLATE}.make,
				covers/{EL_TEMPLATE}.substituted,
				covers/{EL_EXECUTION_ENVIRONMENT_I}.substituted
			]"
		local
			base_path: FILE_PATH
		do
			base_path := Execution_environment.substituted ("$ISE_LIBRARY/library/base/base.ecf")
			assert ("base.ecf exists", base_path.exists)
		end

feature {NONE} -- Constants

	Date_string: ZSTRING
		once
			Result := "Thursday 23rd November 2017"
		end

end
note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-31 15:47:23 GMT (Sunday 31st January 2021)"
	revision: "5"

class
	GENERAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("character_32_status_queries", agent test_character_32_status_queries)
			eval.call ("any_array_numeric_type_detection", agent test_any_array_numeric_type_detection)
			eval.call ("environment_put", agent test_environment_put)
		end

feature -- Tests

	test_any_array_numeric_type_detection
		local
			array: ARRAY [ANY]
		do
			array := << (1).to_reference, 1.0, (1).to_integer_64 >>
			assert ("same types", array.item (1).generating_type ~ {INTEGER_32_REF})
			assert ("same types", array.item (2).generating_type ~ {DOUBLE})
			assert ("same types", array.item (3).generating_type ~ {INTEGER_64})
		end

	test_character_32_status_queries
		do
--			Bug in finalized exe for compiler version 16.05
--			assert ("not is_space", not ({CHARACTER_32}'€').is_space)
--			assert ("not is_digit ", not ({CHARACTER_32}'€').is_digit)

			assert ("not is_alpha", not ({CHARACTER_32}'€').is_alpha)
			assert ("not is_punctuation", not ({CHARACTER_32}'€').is_punctuation)
			assert ("not is_control", not ({CHARACTER_32}'€').is_control)
		end

	test_environment_put
		local
			name: STRING
		do
			name := "EIFFEL_LOOP_DOC"
			Execution_environment.put ("eiffel-loop", name)
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item (name))
		end

end
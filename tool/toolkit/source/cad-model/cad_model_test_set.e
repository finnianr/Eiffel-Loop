note
	description: "Test set for [$source CAD_MODEL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-16 15:14:30 GMT (Sunday 16th February 2020)"
	revision: "1"

class
	CAD_MODEL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

	EL_MODULE_STRING_8

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("parse_and_conversion",	agent test_parse_and_conversion)
			eval.call ("slicing",	agent test_slicing)
		end

feature -- Test

	test_parse_and_conversion
		local
			model_1, model_2: CAD_MODEL; i: INTEGER
		do
			create model_1.make_from_json (Json_model_line)
			across << "DDDD", "WDDW", "WWWW" >> as code loop
				i := code.cursor_index
				assert ("[" + i.out + "] is " + code.item, model_1.polygon_list.i_th (i).out ~ code.item)
			end
			create model_2.make_from_json (model_1.as_json (False))
			assert ("approximately equal", model_1.is_approximately_equal (model_2, 0.1e-16))
		end

	test_slicing
		local
			model: CAD_MODEL
		do
			create model.make_from_json (Json_model_line)
			lio.put_line (model.dry_part.as_json (False))
			lio.put_line (model.wet_part.as_json (False))
		end

feature {NONE} -- Implementation

	json_model_data: STRING
		do
			Result := "[
				{"q": [[0, 1, 2, 3], [4, 0, 3, 5], [6, 4, 5, 7]]
				, "p": [[-3.021211040636997, 0, 0.14217187491185729]
				, [-2.9544233358350973, 0, 0.52094409745481851]
				, [-2.909539006810594, 0.52094453300079102, 0.51302978605945249]
				, [-2.9763267116124936, 0.52094453300079102, 0.13425756351649126]
				, [-3.0879987454388971, 0, -0.23660034763110396]
				, [-3.0431144164143937, 0.52094453300079102, -0.24451465902646999]
				, [-3.1547864502407967, 0, -0.6153725701740651]
				, [-3.1099021212162934, 0.52094453300079102, -0.62328688156943113]]}
			]"
		end

feature {NONE} -- Constants

	Json_model_line: STRING
		-- JSON model as a single line
		once
			Result := json_model_data
			Result.prune_all ('%N')
		end

end

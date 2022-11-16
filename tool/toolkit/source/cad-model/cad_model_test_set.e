note
	description: "Test set for [$source CAD_MODEL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	CAD_MODEL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("line_intersection",		agent test_line_intersection)
			eval.call ("line_intersection_2",	agent test_line_intersection_2)
			eval.call ("model_load_and_store",	agent test_model_load_and_store)
			eval.call ("slicing",					agent test_slicing)
		end

feature -- Test

	test_model_load_and_store
		local
			model_1, model_2: CAD_MODEL; i: INTEGER
		do
			create model_1.make_from_json (Json_model_unwrapped)
			across << "DDDD", "WDDW", "WWWW" >> as code loop
				i := code.cursor_index
				assert ("[" + i.out + "] is " + code.item, model_1.polygon_list.i_th (i).out ~ code.item)
			end
			create model_2.make_from_json (model_1.as_json (False))
			assert ("approximately equal", model_1.is_approximately_equal (model_2, 0.1e-16))
		end

	test_slicing
		local
			model, model_dry, model_wet: CAD_MODEL
			names: LIST [STRING]; list, dry_list, wet_list: LIST [CAD_POLYGON]
			WDDW_polygon, DDBB_polygon, WWBB_polygon: CAD_POLYGON
		do
			create model.make_from_json (Json_model_unwrapped)
			model_dry := model.dry_part; model_wet := model.wet_part
			list := model.polygon_list; dry_list := model_dry.polygon_list; wet_list := model_wet.polygon_list

			WDDW_polygon := list [2]; DDBB_polygon := dry_list [2]; WWBB_polygon := wet_list [2]

			names := ("FULL,DRY,WET").split (',')
			across << model, model_dry, model_wet >> as l_model loop
				lio.put_labeled_string ("Model", names [l_model.cursor_index]); lio.put_new_line
				l_model.item.print_to (lio)
				lio.put_new_line_x2
			end

			-- B = boundary coord (z=0), W = wet coord (z<0), D = dry coord (z>0)
			assert (Valid_codes, WDDW_polygon.out ~ "WDDW" and DDBB_polygon.out ~ "DDBB" and WWBB_polygon.out ~ "WWBB")

			-- Test dry part
			assert ("dry count 2", dry_list.count = 2)
			assert (Valid_codes, dry_list.i_th (1).out ~ "DDDD")
			assert (Same_coordinates, DDBB_polygon [1] ~ WDDW_polygon [2] and DDBB_polygon [2] ~ WDDW_polygon [3])
			assert (Same_coordinates, surface_intersection (WDDW_polygon [3], WDDW_polygon [4]) ~ DDBB_polygon [3])
			assert (Same_coordinates, surface_intersection (WDDW_polygon [1], WDDW_polygon [2]) ~ DDBB_polygon [4])

			-- Test wet part
			assert ("wet count 2", wet_list.count = 2)
			assert (Valid_codes, wet_list.i_th (1).out ~ "WWWW")
			assert (Same_coordinates, WWBB_polygon [1] ~ WDDW_polygon [4] and WWBB_polygon [2] ~ WDDW_polygon [1])
			assert (Same_coordinates, surface_intersection (WDDW_polygon [1], WDDW_polygon [2]) ~ WWBB_polygon [3])
			assert (Same_coordinates, surface_intersection (WDDW_polygon [3], WDDW_polygon [4]) ~ WWBB_polygon [4])
		end

	test_line_intersection
		local
			p1, p2, answer: COORDINATE_VECTOR
		do
			create p1.make (0.5, 1.5, 3); create p2.make (-0.6, 2.1, -3.5)

			-- Answer from online calculator http://www.ambrsoft.com/TrigoCalc/Plan3D/PlaneLineIntersection_.htm
			create answer.make (-0.007692307692 , 1.776923076923, 0)
			assert ("same answer", surface_intersection (p1, p2).is_approximately_equal (answer, 0.1e-10))
		end

	test_line_intersection_2
		local
			p1, p2, ray, answer: COORDINATE_VECTOR
			plane: PLANE_VECTOR
		do
			ray := [0.0, -1.0, -1.0]
			p1 := [0.0, 0.0, 10.0]; p2 := p1 - ray
			create plane.make (0, 0, 1, 5)

			-- Answer from https://rosettacode.org/wiki/Find_the_intersection_of_a_line_with_a_plane
			create answer.make (0.0, -5.0, 5.0)
			assert ("same answer", plane.intersection_point (p1, p2).is_approximately_equal (answer, 0.1e-10))
		end

feature {NONE} -- Implementation

	surface_intersection (a, b: COORDINATE_VECTOR): COORDINATE_VECTOR
		do
			Result := Surface_plane.intersection_point (a, b)
		end

	json_model_data: STRING
		-- line wrapped data
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

	Json_model_unwrapped: STRING
		-- JSON model as unwrapped line
		once
			Result := json_model_data
			Result.prune_all ('%N')
		end

	Same_coordinates: STRING = "same coordinates"

	Surface_plane: PLANE_VECTOR
		once
			create Result.make (0, 0, 1, 0)
		end

	Valid_codes: STRING = "valid coordinate status codes"

end
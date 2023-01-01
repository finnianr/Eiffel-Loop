note
	description: "Tuple experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 14:31:50 GMT (Saturday 31st December 2022)"
	revision: "6"

class
	TUPLE_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
		end

feature -- Tests

feature -- Basic operations

	assign_string
		local
			tuple: TUPLE [str: READABLE_STRING_GENERAL]
		do
			tuple := ["a"]
			tuple.str := {STRING_32} "b" -- Fails in version 16.05.9.8969 with catcall error. Reported as a bug
		end

	compare_types
		local
			t1: TUPLE [x, y: INTEGER]
			t2: TUPLE [STRING, INTEGER]
			t3: TUPLE [INTEGER]
			t4: TUPLE [STRING]
			t5: TUPLE [x1, y1: INTEGER]
		do
			create t1; t2 := ["", 1]; create t3; create t4; create t5

			across << t1, t2, t3, t4, t5, [1, 2] >> as tuple loop
				lio.put_integer_field (tuple.item.generator, tuple.item.generating_type.type_id)
				lio.put_new_line
			end
			-- t1 and t5 are same type
		end

	creation_from_type
		local
			type: TYPE [TUPLE]
		do
			type := {TUPLE [INTEGER, STRING]}
			lio.put_integer_field ("generic_parameter_count", type.generic_parameter_count)
			lio.put_labeled_string (" generic_parameter_type [1]", type.generic_parameter_type (1).name)
		end

	default_comparison
		do
			if ["one"] ~ ["one"] then
				lio.put_string ("is_object_comparison")
			else
				lio.put_string ("is_reference_comparison")
			end
		end

	find_abstract_type
		local
			tuple: TUPLE [CHARACTER_8]
		do
			create tuple
			lio.put_integer_field ("abstract_type", tuple.item_code (1))
			lio.put_new_line
		end

	set_values
		local
			color: TUPLE [foreground, background: STRING_GENERAL]
		do
			create color
			color.foreground := "blue"
			color.put_reference ("red", 2)
			lio.put_labeled_string ("color.foreground", color.foreground)
			lio.put_new_line
			lio.put_labeled_string ("color.background", color.background)
			lio.put_new_line
		end

	twinning
		local
			t1, t2: TUPLE [name: STRING]
		do
			t1 := ["eiffel"]
			t2 := t1.deep_twin
		end

end
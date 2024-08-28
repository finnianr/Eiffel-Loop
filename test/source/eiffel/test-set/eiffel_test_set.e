note
	description: "General experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 19:44:50 GMT (Wednesday 28th August 2024)"
	revision: "41"

class
	EIFFEL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIRECTORY; EL_MODULE_EIFFEL; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_EXCEPTION

	EL_MODULE_UNIX_SIGNALS

	EL_ZSTRING_CONSTANTS; EL_STRING_32_CONSTANTS

	EL_SHARED_NATIVE_STRING

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["array_sizes",			 agent test_array_sizes],
				["managed_pointer_twin", agent test_managed_pointer_twin],
				["natural_constant",		 agent test_natural_constant],
				["string_field_counts",	 agent test_string_field_counts],
				["string_sizes",			 agent test_string_sizes],
				["unix_sigterm",			 agent test_unix_sigterm]
			>>)
		end

feature -- Tests

	test_array_sizes
		-- EIFFEL_TEST_SET.test_array_sizes
		local
			object_array: SPECIAL [STRING]; pointer_array: SPECIAL [POINTER]
			c_1: SPECIAL [CHARACTER]; c_1_size, array_size, array_overhead, reference_size: INTEGER
		do
			array_overhead := 32 -- object header
			across << 16, 32, 64, 128 >> as size loop
				create object_array.make_empty (size.item)
				array_size := Eiffel.physical_size (object_array)
				reference_size := (array_size - array_overhead) // object_array.capacity
				assert ("reference size same as pointer", reference_size = {PLATFORM}.pointer_bytes)
			end
		end

	test_managed_pointer_twin
		-- EIFFEL_TEST_SET.test_managed_pointer_twin
		do
			Native_string.set_string ("runas")
			if attached Native_string.managed_data as data
				and then attached data.twin as data_twin
			then
				assert ("different instance", Native_string.managed_data /= data_twin)
				assert ("different pointer", Native_string.managed_data.item /= data_twin.item)
				assert ("same data", Native_string.managed_data ~ data_twin)
			end
		end

	test_natural_constant
		do
			assert ("same value", {EL_ASCII}.Newline = {EL_ASCII}.Line_feed)
		end

	test_string_field_counts
		-- EIFFEL_TEST_SET.test_string_field_counts
		local
			object_str, object_str_32: REFLECTED_REFERENCE_OBJECT
		do
			create object_str.make (Empty_string)
			create object_str_32.make (Empty_string_32)
			assert ("ZSTRING has more fields", object_str.field_count > object_str_32.field_count)
		end

	test_string_sizes
		-- EIFFEL_TEST_SET.test_string_sizes
		do
			assert ("same size", Eiffel.physical_size (Empty_string) = Eiffel.physical_size (Empty_string_32))
		end

	test_unix_sigterm
		do
			assert ("is 15", Unix_signals.Sigterm = 15)
		end

feature -- Access

	b_1: BOOLEAN

	i_1: INTEGER

feature -- Equal to comparison

	is_a_equal_to_b (a, b: INTEGER): BOOLEAN
		do
			if a = b then
				Result := True
			end
		end

	is_a_equal_to_b_ref (a, b: INTEGER_REF): BOOLEAN
		do
			if a = b then
				Result := True
			end
		end

feature -- Less than or equal to comparison

	is_a_less_than_or_equal_to_b (a, b: INTEGER): BOOLEAN
		do
			if a <= b then
				Result := True
			end
		end


	is_a_less_than_or_equal_to_b_ref (a, b: INTEGER_REF): BOOLEAN
		do
			if a <= b then
				Result := True
			end
		end

feature -- Basic operations

	array_manifest_types
		local
			array_2d: ARRAY [ANY]
		do
			array_2d := <<
				<< 1, 2 >>
			>>
			if attached {ARRAY [INTEGER]} array_2d [1] as integers then
				lio.put_integer_field ("integers", integers [1])
			end
			if attached {ARRAY [NATURAL]} array_2d [1] as naturals then
				lio.put_natural_field ("naturals", naturals [1])
			end
			lio.put_new_line
		end

	boolean_option
		local
			option: EL_BOOLEAN_OPTION
		do
			option := True
			lio.put_labeled_string ("option", option.is_enabled.out)
			lio.put_new_line
		end

	boolean_ref
		local
			b1: BOOLEAN
			b1_ref, b2_ref: BOOLEAN
		do
			b1_ref := b1.to_reference
			b2_ref := not b1_ref
			lio.put_string ("b2_ref.item: ")
			lio.put_boolean (b2_ref.item)
		end

	char_compression
		local
			a_fold: ARRAY [CHARACTER]
			fold_i_m_1_i: NATURAL; i: INTEGER
		do
			io.put_string ("Constant: "); io.put_natural ((('W').natural_32_code |<< 8) | ('W').natural_32_code)
			a_fold := << 'N', 'W' >>
			i := 2
			inspect ((a_fold [i - 1]).natural_32_code |<< 8) | (a_fold [i]).natural_32_code
				when Dir_n_n then
				when Dir_n_w then
				when Dir_w_w then

				-- and so forth
			else
			end
		end

	create_makeable_object
		local
			f: EL_MAKEABLE_OBJECT_FACTORY
		do
			create f
			if attached {COLUMN_VECTOR_COMPLEX_64} f.new_item_from_name ("COLUMN_VECTOR_COMPLEX_64") as vector then
				lio.put_line ("success")
			end
		end

	equality_question
		local
			s1: STRING; s2: READABLE_STRING_GENERAL
			s1_equal_to_s2: BOOLEAN
		do
			s1 := "abc"; s2 := "abc"
			s1_equal_to_s2 := s1 ~ s2
			lio.put_labeled_string ("s1 is equal to s2", s1_equal_to_s2.out)
		end

	once_order_test (a_first: BOOLEAN)
		local
--			a, b: A; c: CHARACTER
			a: A; b: B; c: CHARACTER
		do
--			create a; create {B} b
			create a.make; create b.make
			if a_first then
				c := a.character; c := b.character
			else
				c := b.character; c := a.character
			end

			lio.put_string ("a.character: " + a.character.out)
			lio.put_string (" b.character: " + b.character.out)
			lio.put_new_line
		end

	once_same_for_classes
		local
			a: A; b: B
		do
			create a.make; create b.make
			lio.put_line (a.once_xxx + b.once_xxx)
			if a.once_xxx = b.once_xxx then
				lio.put_line ("same object")
			end
		end

	or_expression_evaluation
		local
			bool: BOOLEAN
		do
			bool := is_true or is_false
		end

	pointer_width
		local
			ptr: POINTER
		do
			ptr := $pointer_width
			lio.put_integer_field (ptr.out, ptr.out.count)
		end

	print_field_pointers
		local
			p_i_1, p_b_1, object_ptr: POINTER; i, field_count, offset: INTEGER
			reflected: REFLECTED_REFERENCE_OBJECT
		do
			p_i_1 := $i_1
			p_b_1 := $b_1
			create reflected.make (Current)
			object_ptr := reflected.object_address
			lio.put_labeled_string ("Pointer object", object_ptr.out)
			lio.put_new_line
			lio.put_labeled_string ("Pointer object + 4", (object_ptr + 4).out)
			lio.put_new_line_x2

			field_count := reflected.field_count
			from i := 1 until i > field_count loop
				lio.put_integer_field ("Offset " + reflected.field_name (i), reflected.field_offset (i))
				lio.put_new_line
				i := i + 1
			end
			lio.put_new_line

			lio.put_labeled_string ("Offset b_1", p_b_1.out)
			lio.put_new_line
			lio.put_labeled_string ("Offset i_1", p_i_1.out)
			lio.put_new_line_x2
		end

	problem_with_function_returning_real_with_assignment
			--
		local
			event: AUDIO_EVENT
		do
			create event.make (1.25907 ,1.38513)
			lio.put_string ("Is threshold exceeded: ")
			if event.is_threshold_exceeded (0.12606) then
				lio.put_string ("true")
			else
				lio.put_string ("false")
			end
			lio.put_new_line
		end

	problem_with_function_returning_result_with_set_item
			-- if {AUDIO_EVENT}
		local
			event_list: LINKED_LIST [AUDIO_EVENT]
			event: AUDIO_EVENT
		do
			create event_list.make
			create event.make (1.25907 ,1.38513)
			event_list.extend (event)

			lio.put_real_field ("event_list.last.duration", event_list.last.duration, Void)
			lio.put_new_line
		end

	put_execution_environment_variables
		do
			Execution_environment.put ("sausage", "SSL_PW")
			Execution_environment.system ("echo Password: $SSL_PW")
		end

	transient_fields
		local
			field_count, i: INTEGER
		do
			field_count := Eiffel.field_count (Current)
			from i := 1 until i > field_count loop
				lio.put_index_labeled_string (i, Void, Eiffel.field_name (i, Current))
				lio.put_character (' '); lio.put_boolean (Eiffel.is_field_transient (i, Current))
				lio.put_new_line
				i := i + 1
			end
		end

feature {NONE} -- Implemenation

	is_false: BOOLEAN
		do
			lio.put_line ("is_false")
		end

	is_true: BOOLEAN
		do
			Result := True
			lio.put_line ("is_true")
		end

feature {NONE} -- Constants

	Dir_n_n: NATURAL = 20046

	Dir_n_w: NATURAL = 20055

	Dir_w_w: NATURAL = 22359

end
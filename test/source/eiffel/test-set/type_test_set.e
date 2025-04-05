note
	description: "Type experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 18:02:59 GMT (Friday 4th April 2025)"
	revision: "24"

class
	TYPE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_EIFFEL_C_API
		undefine
			default_create
		end

	EL_STRING_HANDLER

	EL_MODULE_EIFFEL

	EL_ZSTRING_CONSTANTS

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["abstract_type_of_type_plus",	 agent test_abstract_type_of_type_plus],
				["find_readable_string_32_types", agent test_find_readable_string_32_types],
				["string_factory_creation",		 agent test_string_factory_creation],
				["type_and_type_name_caching",	 agent test_type_and_type_name_caching],
				["type_characteristics_query",	 agent test_type_characteristics_query],
				["type_flag_permutations",			 agent test_type_flag_permutations]
			>>)
		end

feature -- Tests

	test_abstract_type_of_type_plus
		-- TYPE_TEST_SET.test_abstract_type_of_type_plus
		note
			testing: "[
				covers/{EL_TYPE_UTILITIES}.abstract_type_of_type_plus
			]"
		local
			null_array: ARRAY [POINTER_REF]; null: POINTER; type_id, l_type, last_abstract_type: INTEGER
			type_name, integer_ref_name: STRING; bit_width: INTEGER
		do
			integer_ref_name := "INTEGER_32_REF"

		-- Important to test type with abstract type of zero
			null_array := << null, null.to_reference >>
			across null_array as array loop
				l_type := Eiffel.abstract_type_of_type_plus (Eiffel.dynamic_type (array.item))
				assert ("valid abstract type", l_type = {REFLECTOR_CONSTANTS}.Pointer_type)
			end

			across << "INTEGER", "NATURAL", "REAL" >> as type loop
				if attached type.item as root then
					create type_name.make_from_string (root)
					from bit_width := 8 until bit_width > 64 loop
						type_name.keep_head (root.count)
						if type.is_last implies bit_width >= 32 then
							across << "", "_REF" >> as suffix loop
								if suffix.is_first then
									type_name.append_character ('_')
									type_name.append_integer (bit_width)
								end
								type_name.append (suffix.item)
								last_abstract_type := Eiffel.abstract_type_of_type_plus (type_id)
								if type_name ~ integer_ref_name then
									do_nothing
								end
								type_id := Eiffel.dynamic_type_from_string (type_name.twin) -- must be twinned for search to work
								lio.put_integer_field (type_name, type_id)
								if suffix.is_last then
									lio.put_new_line
									assert ("same abstract type", last_abstract_type = Eiffel.abstract_type_of_type_plus (type_id))
								else
									lio.put_spaces (1)
								end
							end
						end
						bit_width := bit_width * 2
					end
				end
			end
		end

	test_find_readable_string_32_types
		-- TYPE_TEST_SET.test_find_readable_string_32_types
		local
			type_id, type_size: INTEGER; break: BOOLEAN
			type_flags: NATURAL_16
		do
			from type_id := 0 until break loop
				type_flags := eif_type_flags (type_id)
				type_size := eif_type_size (type_id)
				if type_size >= 24
					and then (type_flags = 0 or Eiffel.is_type_frozen (type_flags))
					and then not Eiffel.is_generic (type_id)
					and then {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.READABLE_STRING_32)
				then
					lio.put_labeled_string (type_id.out, {ISE_RUNTIME}.generating_type_of_type (type_id))
					lio.put_new_line
					if type_id = Class_id.ZSTRING then
						break := True
					end
				end
				type_id := type_id + 1 + Eiffel.is_type_expanded (type_flags).to_integer
			end
		end

	test_string_factory_creation
		-- Establish basis for creating class EL_INITIALIZED_OBJECT_FACTORY
		local
			factory: EL_OBJECT_FACTORY [EL_STRING_FACTORY [READABLE_STRING_GENERAL]]
		do
			create factory
			if attached factory.new_item_from_name ("EL_STRING_FACTORY [EL_ZSTRING]") as zstr_factory then
				assert ("created", True)
				if attached zstr_factory.new_item as str then
					lio.put_labeled_string ("Type", str.generator)
					lio.put_new_line
					assert ("is empty string", str.count = 0)
				else
					failed ("new string created")
				end

			else
				failed ("created")
			end
		end

	test_type_and_type_name_caching
		-- TYPE_TEST_SET.test_type_and_type_name_caching
		local
			t1, t2: TYPE [READABLE_STRING_32]
			name_1, name_2: IMMUTABLE_STRING_8
		do
			t1 := {EL_ZSTRING}; t2 := {EL_ZSTRING}
			name_1 := t1.name; name_2 := t2.name
			assert ("same instance", t1 = t2)
			assert ("same instance", t1 = zstring_type)
			assert ("same as generating_type", t1 = Empty_string.generating_type)
			assert ("same instance", name_1 = name_2)

			if attached {TYPE [READABLE_STRING_32]} Eiffel.type_of_type (t1.type_id) as t3 then
				assert ("same instance", t1 = t3)
			else
				failed ("same type")
			end
		end

	test_type_characteristics_query
		-- TYPE_TEST_SET.test_type_characteristics_query
		note
			testing: "[
				covers/{EL_INTERNAL}.type_flag_names,
				covers/{EL_EIFFEL_C_API}.eif_type_size,
				covers/{EL_EIFFEL_C_API}.eif_generic_parameter_count,
				covers/{EL_EIFFEL_C_API}.eif_type_flags
			]"
		do
			assert_characteristics ({INTEGER_32}, 0, 8, "declared-expanded expanded frozen")
			assert_characteristics ({SET [ANY]}, 1, 8, "deferred")
			assert_characteristics ({EL_MUTEX_VALUE [NATURAL]}, 1, 24, "has-dispose")
			assert_characteristics ({EL_CHOICE [NATURAL]}, 1, 0, "declared-expanded expanded")
			assert_characteristics ({SPECIAL [INTEGER_32]}, 1, 0, "special frozen")
			assert_characteristics ({HASH_TABLE [INTEGER, STRING]}, 2, 80, "")
			assert_characteristics ({TUPLE [STRING]}, 1, 0, "tuple")
			assert_characteristics ({EL_DYNAMIC_MODULE [EL_DYNAMIC_MODULE_POINTERS]}, 1, 32, "has-dispose deferred")
			assert_characteristics ({VECTOR_COMPLEX_64}, 0, 176, "composite deferred")
			assert_characteristics ({ROW_VECTOR_COMPLEX_64}, 0, 176, "composite")
		end

	test_type_flag_permutations
		-- TYPE_TEST_SET.test_type_flag_permutations
		local
			type_id: INTEGER; break: BOOLEAN
			type_flags: NATURAL_16; type_flags_set: EL_HASH_SET [NATURAL_16]
		do
			create type_flags_set.make (20)
			from type_id := 1 until type_id > 3_000 or break loop
				if attached {ISE_RUNTIME}.generating_type_of_type (type_id) as name then
					type_flags := eif_type_flags (type_id)
					type_flags_set.put (type_flags)
					if type_flags_set.inserted then
						lio.put_integer_field (name, type_id)
						if attached Eiffel.type_flag_names (type_flags) as list and then list.count > 0 then
							lio.put_labeled_string (" Flags", list.as_word_string)
						end
						lio.put_new_line
					end
					type_id := type_id + Eiffel.is_type_expanded (type_flags).to_integer + 1
				else
					lio.put_integer_field ("break at type_id", type_id)
					lio.put_new_line
					break := True
				end
			end
			assert ("flag permutation count = 11", type_flags_set.count = 11)
		end

feature {NONE} -- Implementation

	assert_characteristics (type: TYPE [ANY]; a_parameter_count, a_type_size: INTEGER; flags: STRING)
		local
			type_id, type_size, parameter_count: INTEGER
			flag_names, expected_flag_names: EL_STRING_8_LIST
		do
			type_id := type.type_id
			type_size := eif_type_size (type_id)
			parameter_count := eif_generic_parameter_count (type_id)
			flag_names := Eiffel.type_flag_names (eif_type_flags (type_id))
			create expected_flag_names.make_split (flags, ' ')

			if flag_names /~ expected_flag_names or type_size /= a_type_size
				or parameter_count /= a_parameter_count
			then
				lio.put_labeled_string ("Actual characteristics", type.name)
				lio.put_integer_field (" Parameters", parameter_count)
				lio.put_integer_field (" Size", type_size)
				if flag_names.count > 0 then
					lio.put_labeled_string (" Flags", flag_names.as_word_string)
				end
				lio.put_new_line
				failed ("characteristics match")
			end
		end

	zstring_type: TYPE [READABLE_STRING_32]
		do
			Result := {ZSTRING}
		end

feature {NONE} -- Constants

	Eros_factory: EL_OBJECT_FACTORY [EROS_REMOTELY_ACCESSIBLE]
			--
		once
			create Result
		end
end
note
	description: "Type experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-08 17:21:37 GMT (Tuesday 8th October 2024)"
	revision: "18"

class
	TYPE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

	EL_ZSTRING_CONSTANTS

	EL_SHARED_CLASS_ID

	EL_EIFFEL_C_API
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["find_readable_string_32_types", agent test_find_readable_string_32_types],
				["string_factory_creation",		 agent test_string_factory_creation],
				["type_and_type_name_caching",	 agent test_type_and_type_name_caching],
				["type_iteration",					 agent test_type_iteration]
			>>)
		end

feature -- Tests

	test_find_readable_string_32_types
		-- TYPE_TEST_SET.test_find_readable_string_32_types
		local
			type_id, attached_type, type_size: INTEGER; break, conforms_to_type: BOOLEAN
			type_flags: NATURAL_16
		do
			from type_id := 0 until break loop
				type_flags := eif_type_flags (type_id)
				type_size := eif_type_size (type_id)
				if Eiffel.is_special_any_type (type_id) then
					do_nothing

				elseif Eiffel.is_tuple_type (type_id) then
					do_nothing

				elseif type_size >= 24
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

	test_type_iteration
		-- TYPE_TEST_SET.test_type_iteration
		local
			type_id, attached_type, type_size: INTEGER; break, conforms_to_type: BOOLEAN
			type_flags: NATURAL_16
		do
			from type_id := 0 until type_id > 100 or break loop
				type_flags := eif_type_flags (type_id)
				type_size := eif_type_size (type_id)
--				if Eiffel.is_special_type (type_id) then
--					lio.put_labeled_string (type_id.out, "SPECIAL")
--					lio.put_new_line

--				elseif Eiffel.is_tuple_type (type_id) then
--					lio.put_labeled_string (type_id.out, "TUPLE")
--					lio.put_new_line

--				else
				if attached {ISE_RUNTIME}.generating_type_of_type (type_id) as name then
					lio.put_labeled_string (type_id.out, name)
					lio.put_integer_field (" Parameters", eif_generic_parameter_count (type_id))
					lio.put_integer_field (" Size", type_size)
					if attached Eiffel.type_flag_names (type_flags) as list and then list.count > 0 then
						lio.put_labeled_string (" Flags", list.joined_words)
					end
					lio.put_new_line
				else
					break := True
				end
				type_id := type_id + 1 + Eiffel.is_type_expanded (type_flags).to_integer
			end
		end

feature -- Basic operations

	conforming_types
		do
			if {ISE_RUNTIME}.type_conforms_to (
				({EL_STANDARD_UNINSTALL_APP}).type_id, ({EL_INSTALLABLE_APPLICATION}).type_id
				) then
				lio.put_line ("Conforms")
			end
		end

	generic_type_check
		local
			list: LIST [STRING_GENERAL]
			type: TYPE [ANY]
		do
			create {EL_ZSTRING_LIST} list.make (0)
			type := list.generating_type.generic_parameter_type (1)
		end

	generic_types
		local
			type_8, type_32: TYPE [LIST [READABLE_STRING_GENERAL]]
		do
			type_8 := {ARRAYED_LIST [STRING]}
			type_32 := {ARRAYED_LIST [STRING_32]}
		end

	valid_class_name
		do
			lio.put_labeled_string ("FFT_COMPLEX_DOUBLE", Eros_factory.valid_name ("FFT_COMPLEX_64").out)
			lio.put_new_line
		end

feature {NONE} -- Implementation

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
note
	description: "Type experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 10:24:32 GMT (Tuesday 15th August 2023)"
	revision: "15"

class
	TYPE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["string_factory_creation", agent test_string_factory_creation],
				["type_and_type_name_caching", agent test_type_and_type_name_caching]
			>>)
		end

feature -- Tests

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
		local
			t1, t2: TYPE [READABLE_STRING_32]
			name_1, name_2: IMMUTABLE_STRING_8
		do
			t1 := {EL_ZSTRING}; t2 := {EL_ZSTRING}
			name_1 := t1.name; name_2 := t2.name
			assert ("same instance", t1 = t2)
			assert ("same instance", name_1 = name_2)

			if attached {TYPE [READABLE_STRING_32]} Eiffel.type_of_type (t1.type_id) as t3 then
				assert ("same instance", t1 = t3)
			else
				failed ("same type")
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

feature {NONE} -- Constants

	Eros_factory: EL_OBJECT_FACTORY [EROS_REMOTELY_ACCESSIBLE]
			--
		once
			create Result
		end
end
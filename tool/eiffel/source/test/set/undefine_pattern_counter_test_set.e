note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-04 16:03:52 GMT (Tuesday 4th January 2022)"
	revision: "11"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	EL_EQA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("command", agent test_command)
		end

feature -- Tests

	test_command
		local
			command: UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			create command.make ("test-data/base-manifest.pyx", create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute
			if attached command.greater_than_0_list as list then
				assert ("3 in list", list.count = 3)
				from list.start until list.after loop
					assert ("2 patterns found", list.item_value = 2)
					assert ("matches type",
						some_type_matches (<< {EL_SETTABLE_FROM_STRING}, {EL_PATH}, {EL_PATH_STEPS} >>, list.item_key)
					)
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	some_type_matches (type_list: ARRAY [TYPE [ANY]]; file_name: ZSTRING): BOOLEAN
		local
			src_name: ZSTRING
		do
			across type_list as type until Result loop
				create src_name.make_from_general (type.item.name)
				src_name.to_lower
				src_name.append_string_general (".e")
				Result := src_name ~ file_name
			end
		end

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor
			-- Renew EIFFEL_LOOP after publisher tests
			Execution_environment.put (new_eiffel_loop_dir, Var_eiffel_loop)
		end

end
note
	description: "[
		Sub-application allowing execution of multiple EQA unit tests. A summary of any failed tests is
		printed when all tests have finished executing.

		See ${BASE_AUTOTEST_APP} as an example.
	]"
	notes: "[
		Add command option `-test_set' <name> to test with named test
		
		Logging is active by default
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 10:26:17 GMT (Tuesday 2nd April 2024)"
	revision: "25"

deferred class
	EL_AUTOTEST_APPLICATION [EQA_TYPES -> TUPLE create default_create end]

inherit
	EL_LOGGED_APPLICATION
		redefine
			is_logging_active, init_console_and_logging
		end

	EL_MODULE_ARGS; EL_MODULE_EIFFEL; EL_MODULE_NAMING

feature {NONE} -- Initialization

	init_console_and_logging
		local
			s: EL_STRING_8_ROUTINES; start_index, count: INTEGER
		do
			start_index := 1; count := App_option.test_set.count
			test_set_name := s.substring_to_from (App_option.test_set, '.', $start_index)
			if start_index < count then
				test_name := App_option.test_set.substring (start_index, count)
				if test_name.starts_with (Test_prefix) then
					test_name.remove_head (Test_prefix.count)
				end
			else
				create test_name.make_empty
			end
			if test_set_name.is_empty then
				create test_type_list.make_from_list (new_test_type_list)

			elseif test_set_name.has ('*') then
				create test_type_list.make_from_if (new_test_type_list, agent matching_type_name)
			else
				create test_type_list.make_from_if (new_test_type_list, agent same_type_name)
			end
			Precursor
		end

	initialize
		do
		ensure then
			all_conform_to_EL_EQA_TEST_SET: test_type_list.all_conform
		end

feature -- Basic operations

	run
		local
			failed_list: EL_ARRAYED_LIST [EL_TEST_SET_EVALUATOR]
			evaluator: EL_TEST_SET_EVALUATOR
		do
			if test_type_list.is_empty and then App_option.test_set.count > 0 then
				lio.put_labeled_string ("No such test set", App_option.test_set)
				lio.put_new_line

			elseif test_type_list.all_conform then
				create failed_list.make_empty
				across test_type_list as type loop
					create evaluator.make (type.item, test_name)
					evaluator.execute
					if evaluator.has_failure then
						failed_list.extend (evaluator)
					end
					lio.put_new_line
				end
				if failed_list.is_empty then
					lio.put_line ("All tests PASSED OK")
				else
					lio.put_line ("The following tests failed")
					lio.put_new_line
					across failed_list as failed loop
						failed.item.print_failures
					end
					exit_code := 1
				end
			else
				across test_type_list.non_conforming_list as type loop
					lio.put_labeled_string (type.item.name, "type does not conform to " + ({EL_TEST_SET_EVALUATOR}).name)
				end
			end
		end

feature {NONE} -- Implementation

	description: STRING
		local
			name: STRING
		do
			Result := "Call EQA test sets for:%N"
			across new_test_type_list as type loop
				name := type.item.name
				if name.ends_with (Test_set_suffix) then
					name.remove_tail (Test_set_suffix.count)
				end
				Result.append ("%N   ")
				Result.append (Naming.class_description (name, Naming.No_words))
				Result.append (" classes")
			end
		end

	is_logging_active: BOOLEAN
		do
			Result := True
		end

	log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		local
			type_list: like test_type_list
		do
			type_list := test_type_list
			create Result.make_with_count (type_list.count + 1)
			Result.show_all ({like Current})
			across type_list as list loop
				if attached {TYPE [EL_MODULE_LOG]} list.item as log_type then
					Result.show_all (log_type)
				end
			end
		end

	matching_type_name (type: TYPE [EL_EQA_TEST_SET]): BOOLEAN
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.matches_wildcard (type.name, test_set_name)
		end

	new_test_type_list: EL_TUPLE_TYPE_LIST [EL_EQA_TEST_SET]
		do
			create Result.make_from_tuple (create {EQA_TYPES})
		end

	same_type_name (type: TYPE [EL_EQA_TEST_SET]): BOOLEAN
		do
			Result := type.name.same_string (test_set_name)
		end

feature {NONE} -- Internal attributes

	test_name: STRING

	test_set_name: STRING

	test_type_list: like new_test_type_list

feature {NONE} -- Constants

	Test_prefix: STRING = "test_"

	Test_set_suffix: STRING = "_TEST_SET"

note
	descendants: "[
			EL_AUTOTEST_APPLICATION* [EQA_TYPES -> ${TUPLE} create default_create end]
				${MULTIMEDIA_AUTOTEST_APP}
				${EL_CRC_32_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
					${TAGLIB_AUTOTEST_APP}
					${PYXIS_SCAN_AUTOTEST_APP}
					${TEXT_FORMATS_AUTOTEST_APP}
					${VTD_XML_AUTOTEST_APP}
					${XML_SCAN_AUTOTEST_APP}
					${NETWORK_AUTOTEST_APP}
					${ECO_DB_AUTOTEST_APP}
					${EVOLICITY_AUTOTEST_APP}
					${I18N_AUTOTEST_APP}
					${IMAGE_UTILS_AUTOTEST_APP}
					${OPEN_OFFICE_AUTOTEST_APP}
					${THUNDERBIRD_AUTOTEST_APP}
				${PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP}
				${PUBLIC_KEY_ENCRYPTION_AUTOTEST_APP}
				${SEARCH_ENGINE_AUTOTEST_APP}
				${TEXT_PROCESS_AUTOTEST_APP}
				${EROS_AUTOTEST_APP}
				${HTTP_CLIENT_AUTOTEST_APP}
				${AMAZON_INSTANT_ACCESS_AUTOTEST_APP}
				${C_LANGUAGE_INTERFACE_AUTOTEST_APP}
				${COMPRESSION_AUTOTEST_APP}
				${CURRENCY_AUTOTEST_APP}
				${EIFFEL_AUTOTEST_APP}
				${ENCRYPTION_AUTOTEST_APP}
				${FILE_PROCESSING_AUTOTEST_APP}
				${OS_COMMAND_AUTOTEST_APP}
				${BASE_AUTOTEST_APP}
	]"
end
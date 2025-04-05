note
	description: "[
		${EQA_TEST_SET} with tests that can be invoked individually or consecutively
		from the command line. Useful also for testing in a finalized application which
		sometimes reveals a different behaviour to that of the workbench mode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 8:20:14 GMT (Saturday 5th April 2025)"
	revision: "31"

deferred class
	EL_EQA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
		redefine
			on_clean, on_prepare, assert_32
		end

	EL_MAKEABLE undefine default_create end

	EL_MODULE_LIO -- so test can still be run in AutoTest tool

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_OS

	EL_SHARED_DIGESTS; EL_SHARED_TEST_CRC

feature {NONE} -- Initialization

	make
		-- partial make to satisfy `EQA_TEST_SET' invariant `file_system.asserter = asserter'
		deferred
		end

	make_named (test_array: ARRAY [TUPLE [STRING, PROCEDURE]])
		do
			eqa_file_system := new_file_system
			create test_table.make_assignments (test_array)
		end

feature -- Access

	test_table: detachable EL_PROCEDURE_TABLE [STRING]
		-- named test routines

feature -- Factory

	new_evaluator: EQA_TEST_EVALUATOR [like Current]
		do
			create Result
		end

feature -- Assertions

	assert_32 (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
		do
			asserter.assert (a_tag.to_string_32, a_condition) -- incase `a_tag' is ZSTRING
		end

	assert_approximately_equal (a_tag: detachable STRING; decimal_places: INTEGER; a, b: DOUBLE)
		local
			tag: STRING; double: EL_DOUBLE_MATH
		do
			if attached a_tag as l_tag then
				tag := l_tag
			else
				tag := "a almost equal to b with precision of 1e-" + decimal_places.out
			end
			assert (tag, double.approximately_equal (a, b, 10 ^ decimal_places.opposite))
		end

	assert_found (a_tag: STRING; container: CONTAINER [ANY]; condition: BOOLEAN)
		do
			assert_found_32 (a_tag, container, condition)
		end

	assert_found_32 (a_tag: READABLE_STRING_GENERAL; container: CONTAINER [ANY]; condition: BOOLEAN)
		do
			if attached {EL_LINEAR [ANY]} container as list and then list.found then
				assert_32 (a_tag, condition)

			elseif attached {HASH_TABLE [ANY, HASHABLE]} container as table and then table.found then
				assert_32 (a_tag, condition)

			elseif attached {EL_HASH_SET [HASHABLE]} container as set and then set.found then
				assert_32 (a_tag, condition)
			else
				failed ("found")
			end
		end

	assert_same_string (a_tag: detachable READABLE_STRING_GENERAL; a, b: READABLE_STRING_GENERAL)
		local
			tag: READABLE_STRING_GENERAL
		do
			if attached a_tag as l_tag then
				tag := l_tag
			else
				tag := "same string"
			end
			if a.count /= b.count then
				lio.put_integer_field ("a.count", a.count); lio.put_integer_field (" b.count", b.count)
				lio.put_new_line
				if attached a_tag then
					assert_32 (tag, False)
				else
					assert ("String a.count = b.count", False)
				end

			elseif not a.same_string (b) then
				lio.put_curtailed_string_field (a.generator + " a", a, 200)
				lio.put_new_line
				lio.put_curtailed_string_field (b.generator + " b", b, 200)
				lio.put_new_line
				assert_32 (tag, False)
			end
		end

	failed (a_tag: READABLE_STRING_GENERAL)
		do
			assert_32 (a_tag, False)
		end

feature {NONE} -- Implementation

	os_checksum (unix, windows: NATURAL): NATURAL
		do
			if {PLATFORM}.is_unix then
				Result := unix
			else
				Result := windows
			end
		end

	new_string_type_list (str: READABLE_STRING_GENERAL): ARRAYED_LIST [READABLE_STRING_GENERAL]
		-- list of 5 permutations of string type for `str'
		do
			create Result.make (5)
			if attached str.to_string_32 as str_32 then
				Result.extend (str_32)
				Result.extend (create {IMMUTABLE_STRING_32}.make_from_string (str_32))
				if str_32.is_valid_as_string_8 and then attached str_32.to_string_8 as str_8 then
					Result.extend (str_8)
					Result.extend (create {IMMUTABLE_STRING_8}.make_from_string (str_8))
				end
				Result.extend (create {ZSTRING}.make_from_string (str_32))
			end
		end

	plain_text_digest (file_path: FILE_PATH): EL_DIGEST_ARRAY
		do
			create Result.make_from_plain_text (MD5_128, file_path)
		end

	raw_file_digest (file_path: FILE_PATH): EL_DIGEST_ARRAY
		do
			create Result.make_from_memory (MD5_128, File.data (file_path))
		end

	set_test_path_value (path: EL_PATH; value: READABLE_STRING_GENERAL)
		-- temporarily set value of `path' to be restored to original during `on_clean' event call
		do
			saved_path_list.extend (path, path.to_string)
			path.set_path (value)
		end

feature {NONE} -- Event handling

	on_clean
		do
			if attached saved_path_list as list then
				from list.start until list.after loop
					list.item_key.set_path (list.item_value)
					list.remove
				end
			end
		ensure then
			saved_path_list_empty: saved_path_list.is_empty
		end

	on_prepare
		local
			global: EL_SINGLETON [EL_GLOBAL_LOGGING]
			logging: EL_GLOBAL_LOGGING
		do
			create global
			if not global.is_created then
				create logging.make (False)
			end
			create saved_path_list.make_empty
		end

feature {NONE} -- Internal attributes

	saved_path_list: EL_ARRAYED_MAP_LIST [EL_PATH, ZSTRING]

feature {NONE} -- Constants

	CRC_32_console_only_log: EL_CRC_32_CONSOLE_ONLY_LOG
		once
			create Result.make
		end

end
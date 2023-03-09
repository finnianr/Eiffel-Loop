note
	description: "[$source EQA_TEST_SET] that can be invoked in finalized application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-09 16:01:41 GMT (Thursday 9th March 2023)"
	revision: "17"

deferred class
	EL_EQA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as test_file_system,
			assert as eqa_assert
		redefine
			on_clean, on_prepare
		end

	EL_MAKEABLE undefine default_create end

	EL_MODULE_LIO -- so test can still be run in AutoTest tool

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_OS

	EL_SHARED_DIGESTS; EL_SHARED_TEST_CRC

feature {NONE} -- Initialization

	make
		-- partial make to satisfy `EQA_TEST_SET' invariant
		do
			test_file_system := new_file_system
		end

	make_named (test_array: ARRAY [TUPLE [STRING, PROCEDURE]])
		do
			test_file_system := new_file_system
			create test_table.make (test_array)
		end

feature -- Basic operations

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		deferred
		end

feature -- Access

	test_table: detachable EL_PROCEDURE_TABLE [STRING]

feature -- Factory

	new_evaluator: EQA_TEST_EVALUATOR [like Current]
		do
			create Result
		end

feature {NONE} -- Implementation

	assert (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
		local
			utf: EL_UTF_CONVERTER
		do
			if a_tag.is_valid_as_string_8 then
				eqa_assert (a_tag.to_string_8, a_condition)

			elseif attached {EL_READABLE_ZSTRING} a_tag as zstr then
				eqa_assert (zstr.to_utf_8 (False), a_condition)
			else
				eqa_assert (utf.utf_32_string_to_utf_8_string_8 (a_tag), a_condition)
			end
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
				lio.put_integer_field ("a.count", a.count); lio.put_integer_field (" b.count", a.count)
				lio.put_new_line
				if attached a_tag then
					assert (tag, False)
				else
					assert ("String a.count = b.count", False)
				end

			elseif not a.same_string (b) then
				lio.put_string_field_to_max_length (a.generator + " a", a, 200)
				lio.put_new_line
				lio.put_string_field_to_max_length (b.generator + " b", b, 200)
				lio.put_new_line
				assert (tag, False)
			end
		end

	os_checksum (unix, windows: NATURAL): NATURAL
		do
			if {PLATFORM}.is_unix then
				Result := unix
			else
				Result := windows
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
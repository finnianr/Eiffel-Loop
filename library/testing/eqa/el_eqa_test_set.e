note
	description: "[$source EQA_TEST_SET] that can be invoked in finalized application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-11 16:17:00 GMT (Wednesday 11th January 2023)"
	revision: "13"

deferred class
	EL_EQA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as ise_file_system
		redefine
			on_clean, on_prepare
		end

	EL_MODULE_LIO -- so test can still be run in AutoTest tool

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_OS

	EL_SHARED_DIGESTS; EL_SHARED_TEST_CRC

feature -- Basic operations

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		deferred
		end

feature {NONE} -- Implementation

	assert_same_string (a_tag: detachable STRING; a, b: READABLE_STRING_GENERAL)
		local
			tag: STRING
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
				lio.put_string_field_to_max_length (b.generator + " b", a, 200)
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
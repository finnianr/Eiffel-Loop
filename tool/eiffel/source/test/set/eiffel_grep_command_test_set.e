note
	description: "Test command ${EIFFEL_GREP_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:18:19 GMT (Monday 5th May 2025)"
	revision: "8"

class
	EIFFEL_GREP_COMMAND_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_TUPLE

	SHARED_EIFFEL_LOOP

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["mixed_utf_8_latin_1_encodings", agent test_mixed_utf_8_latin_1_encodings]
			>>)
		end

feature -- Tests

	test_mixed_utf_8_latin_1_encodings
		-- EIFFEL_GREP_COMMAND_TEST_SET.test_mixed_utf_8_latin_1_encodings
		note
			testing:	"[
				covers/{EL_APPENDABLE_ZSTRING}.append_encoded,
				covers/{EL_OS_COMMAND_I}.set_output_encoding
			]"
		local
			cmd: EIFFEL_GREP_COMMAND; count: INTEGER; line: ZSTRING
		do
			if {PLATFORM}.is_unix then
				create cmd.make
				cmd.set_working_directory (eiffel_loop_dir #+ "test/source")
				cmd.set_options ("assert_same_string")
				cmd.execute
				across cmd.lines as list loop
					line := list.item
					if line.has_substring (Line_tag.book_info) then
						assert (Line_tag.book_info + " has euro symbol", line.has (Text.Euro_symbol))
						count := count + 1
					elseif line.has_substring (Line_tag.city) then
						assert (Line_tag.city + " has latin-1 characters > 127", line.has_substring ("D�n B�inne"))
						count := count + 1
					end
				end
				assert ("Both lines found", count = 2)
			else
			--	grep distributed as part of Eiffel Studio for Windows lacks `--include' option
				do_nothing
			end
		end

feature {NONE} -- Constants

	Line_tag: TUPLE [book_info, city: STRING]
		once
			create Result
			Tuple.fill (Result, "book_info.price, transaction.address.city")
		end

end
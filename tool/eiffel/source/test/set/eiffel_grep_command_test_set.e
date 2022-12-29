note
	description: "Test command [$source EIFFEL_GREP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-29 13:10:58 GMT (Thursday 29th December 2022)"
	revision: "1"

class
	EIFFEL_GREP_COMMAND_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_TUPLE

	SHARED_DEV_ENVIRON

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("mixed_utf_8_latin_1_encodings", agent test_mixed_utf_8_latin_1_encodings)
		end

feature -- Tests

	test_mixed_utf_8_latin_1_encodings
		note
			testing:	"covers/{EL_APPENDABLE_ZSTRING}.append_encoded",
					"covers/{EL_OS_COMMAND_I}.set_output_encoding"
		local
			cmd: EIFFEL_GREP_COMMAND; count: INTEGER
		do
			create cmd.make
			cmd.set_working_directory (Dev_environ.Eiffel_loop_dir #+ "test/source")
			cmd.set_options ("assert_same_string")
			cmd.execute
			across cmd.lines as line loop
				if line.item.has_substring (Line_tag.book_info) then
					assert (Line_tag.book_info + " has euro symbol", line.item.has (Text.Euro_symbol))
					count := count + 1
				elseif line.item.has_substring (Line_tag.city) then
					assert (Line_tag.city + " has latin-1 characters > 127", line.item.has_substring ("Dún Búinne"))
					count := count + 1
				end
			end
			assert ("Both lines found", count = 2)
		end

feature {NONE} -- Constants

	Line_tag: TUPLE [book_info, city: STRING]
		once
			create Result
			Tuple.fill (Result, "book_info.price, transaction.address.city")
		end

end
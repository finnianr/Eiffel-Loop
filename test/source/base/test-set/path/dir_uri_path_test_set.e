note
	description: "Dir uri path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-02 11:38:51 GMT (Thursday 2nd April 2020)"
	revision: "6"

class
	DIR_URI_PATH_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("uri_assignments", agent test_uri_assignments)
			eval.call ("directory_join", agent test_directory_join)
		end

feature -- Tests

	test_directory_join
		local
			joined_dir: EL_DIR_PATH; root: EL_DIR_URI_PATH
			joined: ZSTRING
		do
			joined := Uri_strings [1]
			root := joined
			joined_dir := root.joined_dir_path (sd_card)
			joined.append (Sd_card)
			assert ("", joined_dir.to_string ~ joined)
		end

	test_uri_assignments
		local
			uri: EL_DIR_URI_PATH; str_32: STRING_32
		do
			across Uri_strings as line loop
				str_32 := line.item.to_string_32
				create uri.make (str_32)
				assert ("str_32 same as uri.to_string", str_32 ~ uri.to_string.to_string_32)
			end
		end

feature {NONE} -- Constants

	Sd_card: ZSTRING
		once
			Result := "SD Card/Music"
		end

	Uri_strings: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
				mtp://[usb:003,006]/
				http://myching.software/
				http://myching.software/en/home/my-ching.html
				file:///home/finnian/Desktop
			]")
		end

end

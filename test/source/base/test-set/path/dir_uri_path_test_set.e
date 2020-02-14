note
	description: "Dir uri path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 10:54:51 GMT (Friday 14th February 2020)"
	revision: "4"

class
	DIR_URI_PATH_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
		end

feature -- Test routines

	test_uri_assignments
		local
			uri: EL_DIR_URI_PATH; str_32: STRING_32
			uri_list: LIST [STRING]
		do
			uri_list := Uri_strings.split ('%N')
			across uri_list as line loop
				str_32 := line.item.to_string_32
				create uri.make (str_32)
				assert ("str_32 same as uri.to_string", str_32 ~ uri.to_string.to_string_32)
			end
		end

feature {NONE} -- Constants

	Uri_strings: STRING = "[
		file:///home/finnian/Desktop
		http://myching.software/
		http://myching.software/en/home/my-ching.html
	]"

end

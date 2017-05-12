note
	description: "Summary description for {URI_PATH_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-21 11:25:57 GMT (Friday 21st April 2017)"
	revision: "1"

class
	EL_URI_PATH_TEST_SET

inherit
	EQA_TEST_SET

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

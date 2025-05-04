note
	description: "[
		Test routines in class ${is_namespace_aware_file}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 20:58:16 GMT (Sunday 4th May 2025)"
	revision: "3"

class
	XML_TEST_SET

inherit
	EL_DIRECTORY_CONTEXT_TEST_SET

	SHARED_DATA_DIRECTORIES

	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["is_namespace_aware_file", agent test_is_namespace_aware_file]
			>>)
		end

feature -- Tests

	test_is_namespace_aware_file
		note
			testing: "covers/{XML_ROUTINES_IMP}.is_namespace_aware_file"
		do
			across file_name_list as path loop
				if XML.is_namespace_aware_file (path.item) then
				-- uuid.ecf is namespace aware
					assert ("is namespace aware", path.cursor_index <= 2)
				else
					assert ("not namespace aware", path.cursor_index > 2)
				end
			end
		end

feature {NONE} -- Implementation

	file_name_list: EL_STRING_8_LIST
		do
			Result := "Jobs-spreadsheet.fods, uuid.ecf, Rhythmbox.bkup, creatable/request-matrix-average.xml"
		end

	working_dir: DIR_PATH
		do
			Result := Data_dir.xml
		end

end
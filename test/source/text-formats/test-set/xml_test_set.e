note
	description: "[
		Test routines in class ${is_namespace_aware_file}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:23:31 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	XML_TEST_SET

inherit
	EL_DIRECTORY_CONTEXT_TEST_SET

	SHARED_DEV_ENVIRON

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
			across <<
				"XML/Jobs-spreadsheet.fods", "XML/uuid.ecf", -- namespace aware
				"XML/Rhythmbox.bkup", "XML/creatable/request-matrix-average.xml"
			>> as path loop
				if XML.is_namespace_aware_file (path.item) then
					assert ("is namespace aware", path.cursor_index <= 2)
				else
					assert ("not namespace aware", path.cursor_index > 2)
				end
			end
		end

feature {NONE} -- Implementation

	working_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir
		end

end
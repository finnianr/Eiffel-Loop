note
	description: "Test ${OVERRIDE_FEATURE_EDITOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 7:04:53 GMT (Thursday 8th May 2025)"
	revision: "2"

class
	LIBRARY_OVERRIDE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["override_generator", agent test_override_generator]
			>>)
		end

feature -- Tests

	test_override_generator
		-- LIBRARY_OVERRIDE_TEST_SET.override_generator
		local
			command: LIBRARY_OVERRIDE_GENERATOR
		do
			create command.make (Work_area_dir, False)
			command.execute
			lio.put_new_line
			if command.changed_class_list.count > 0 then
				across command.changed_class_list as list loop
					lio.put_path_field ("Changed %S", list.item.output_path)
					lio.put_natural_field (" actual checksum", list.item.actual_checksum)
					lio.put_new_line
				end
				failed ("No changes")
			end
		end

end
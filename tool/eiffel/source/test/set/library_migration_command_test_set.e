note
	description: "Test class [$source LIBRARY_MIGRATION_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-12 15:25:00 GMT (Sunday 12th June 2022)"
	revision: "6"

class
	LIBRARY_MIGRATION_COMMAND_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("migration", agent test_migration)
		end

feature -- Tests

	test_migration
		local
			command: LIBRARY_MIGRATION_TEST_COMMAND; home_dir, destination_dir: DIR_PATH
			relative_path: FILE_PATH; suffix: STRING
		do
			suffix := "-2"
			home_dir := Work_area_dir #+ source_dir.base
			destination_dir := home_dir.parent #+ (home_dir.base + suffix)
			create command.make (home_dir.to_string, home_dir, suffix)
			command.execute

			across OS.file_list (work_area_data_dir, "*.e") as path loop
				if not path.item.has_step (Excluded_imp_step [{PLATFORM}.is_unix]) then
					relative_path := path.item.relative_path (home_dir)
					assert ("destination exists", (destination_dir + relative_path).exists)
				end
			end
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := "test-data/sources/latin-1/os-command"
		end

feature {NONE} -- Constants

	Excluded_imp_step: EL_BOOLEAN_INDEXABLE [ZSTRING]
		once
			create Result.make ("imp_unix", "imp_mswin")
		end

end
note
	description: "Summary description for {ABSENT_PHOTO_DATE_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:06:24 GMT (Thursday 29th June 2017)"
	revision: "2"

class
	ABSENT_PHOTO_DATE_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [ABSENT_PHOTO_DATE]
		redefine
			Option_name, normal_initialize, Test_data_dir
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "jpg" >>)
			Test.do_file_tree_test ("images", agent test_scan, 4017141382)
		end

	test_scan (source_tree_path: EL_DIR_PATH)
			--
		do
			create command.make (source_tree_path, source_tree_path.parent + "absent-dates.txt")
			command.execute
		end

feature {NONE} -- Implementation

	normal_initialize
		do
			Console.show ({ABSENT_PHOTO_DATE})
			Precursor
		end

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [jpeg_tree_dir: EL_DIR_PATH; output_path: EL_FILE_PATH]
		do
			create Result
			Result.jpeg_tree_dir := "."
			Result.output_path := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "absent_photo"

	Description: STRING = "[
		Make list of jpeg photos lacking a "Date time taken" EXIF info
	]"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ABSENT_PHOTO_DATE_APP}, All_routines],
				[{ABSENT_PHOTO_DATE}, All_routines]
			>>
		end

	Test_data_dir: EL_DIR_PATH
			--
		once
			Result := Execution_environment.variable_dir_path ("ISE_EIFFEL").joined_dir_path (
				"contrib/library/network/server/nino/example/SimpleWebServer/webroot/html"
			)
		end

end

note
	description: "[
		Lists JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal'.
		
		See class [$source UNDATED_PHOTO_FINDER] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 9:28:47 GMT (Monday 2nd September 2019)"
	revision: "7"

class
	UNDATED_PHOTO_FINDER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [UNDATED_PHOTO_FINDER]
		redefine
			Option_name, normal_initialize, Test_data_dir
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Console.show ({UNDATED_PHOTO_FINDER})

			Test.set_binary_file_extensions (<< "jpg" >>)
			Test.do_file_tree_test ("images", agent test_scan, 2439913648)
		end

	test_scan (source_tree_path: EL_DIR_PATH)
			--
		do
			create command.make (source_tree_path, source_tree_path.parent + "undated-photos.txt")
			command.execute
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (".", "undated-photos.txt")
		end

	normal_initialize
		do
			Console.show ({UNDATED_PHOTO_FINDER})
			Precursor
		end

feature {NONE} -- Constants

	Option_name: STRING = "undated_photos"

	Description: STRING = "[
		Make list of jpeg photos lacking a "Date time taken" EXIF info
	]"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{UNDATED_PHOTO_FINDER_APP}, All_routines],
				[{UNDATED_PHOTO_FINDER}, All_routines]
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

note
	description: "Source file name normalizer app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:48:25 GMT (Thursday 20th February 2020)"
	revision: "10"

class
	SOURCE_FILE_NAME_NORMALIZER_APP

inherit
	SOURCE_TREE_EDITING_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

create
	make

feature {NONE} -- Implementation

	extra_log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CLASS_FILE_NAME_NORMALIZER}, All_routines]
			>>
		end

	new_editor (file_path_list: LIST [EL_FILE_PATH]): CLASS_FILE_NAME_NORMALIZER
		do
			create Result.make
		end

feature {NONE} -- Constants

	Checksum: ARRAY [NATURAL]
			-- 4 Aug 2016
		once
			Result := << 1536695909, 358964446 >>
		end

	Option_name: STRING = "normalize_class_file_name"

	Description: STRING = "Normalize class filenames as lowercase classnames within a source directory"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Normalize class filenames")
		end

end

note
	description: "Wrapper for [https://www.winzip.com/win/en/prodpagese.html wzipse32 command]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-19 14:20:43 GMT (Monday 19th October 2020)"
	revision: "1"

class
	WINZIP_CREATE_SELF_EXTRACT_COMMAND

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} is_valid_platform
		redefine
			execute
		end

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			-- language option appears twice in Python script. Why is this?
			make_command (
				"wzipse32 $zipped_package_path -Setup -l$language -auto -runasadmin -myesno $text_install_path%
					% -i $package_ico -st $title -t $text_dialog_message_path -o -c $install_command"
			)
		end

feature -- Basic operations

	execute
		local
			path_list: EL_FILE_PATH_LIST
		do
			put_object (config)

			create path_list.make_with_count (2)
			-- write two fields as temporary text files
			across config.field_table as table loop
				if attached {EL_REFLECTED_ZSTRING} table.item as field
					and then field.name.starts_with ("text_")
				then
					path_list.extend (Directory.temporary + File_name #$ [field.name])
					put_path (field.name + "_path", path_list.last_path)
					File_system.write_plain_text (path_list.last_path, field.value (config))
				end
			end
--			Precursor
			across path_list as path loop
				File_system.remove_file (path.item)
			end
		end

feature {NONE} -- Internal attributes

	config: PACKAGE_BUILDER_CONFIG

feature {NONE} -- Constants

	File_name: ZSTRING
		once
			Result := "wzipse32-%S.txt"
		end

end
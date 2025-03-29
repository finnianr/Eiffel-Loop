note
	description: "Wrapper for [https://www.winzip.com/win/en/prodpagese.html wzipse32 command]"
	notes: "[
		Template arguments match wzipse32 arguments fields in ${WINZIP_SOFTWARE_PACKAGE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 14:51:58 GMT (Saturday 29th March 2025)"
	revision: "11"

class
	WINZIP_CREATE_SELF_EXTRACT_COMMAND

inherit
	EL_OS_COMMAND
		rename
			make as make_command
		export
			{NONE} all
			{ANY} is_valid_platform, dry_run
		redefine
			execute
		end

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (a_package: like package)
		do
			package := a_package
			-- language option appears twice in Python script. Why is this?
			make_command (
				"wzipse32 $zip_archive_path -Setup $language_option -auto -runasadmin -myesno $text_install_path%
					% -i $package_ico -st %"$title%" -t $text_dialog_message_path -o -c $install_command"
			)
		end

feature -- Basic operations

	execute
		local
			path_list: EL_FILE_PATH_LIST
		do
			put_fields (package)

			create path_list.make (2)
			-- write two fields as temporary text files
			across package.field_table as table loop
				if attached {EL_REFLECTED_ZSTRING} table.item as field
					and then field.name.starts_with ("text_")
				then
					path_list.extend (Directory.temporary + File_name #$ [field.name])
					put_path (field.name + "_path", path_list.last_path)
					File.write_text (path_list.last_path, field.value (package))
				end
			end
			Precursor -- execute
			across path_list as path loop
				File_system.remove_file (path.item)
			end
		end

feature {NONE} -- Internal attributes

	package: WINZIP_SOFTWARE_PACKAGE

feature {NONE} -- Constants

	File_name: ZSTRING
		once
			Result := "wzipse32-%S.txt"
		end

end
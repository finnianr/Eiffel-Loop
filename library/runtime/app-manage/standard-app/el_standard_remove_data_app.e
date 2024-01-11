note
	description: "[
		Standard application to prompt user to remove (current) application data and configuration files
		directories for all users. Usually called from DEBIAN/prerm script with root permissions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:46:09 GMT (Thursday 11th January 2024)"
	revision: "13"

class
	EL_STANDARD_REMOVE_DATA_APP

inherit
	EL_APPLICATION
		redefine
			option_name
		end

	EL_MODULE_SYSTEM;	EL_MODULE_OS; EL_MODULE_USER_INPUT

	EL_SHARED_APPLICATION_LIST
		export
			{ANY} Application_list
		end

	EL_SHARED_DIRECTORY
		rename
			Directory as OS_directory
		end

	EL_SHARED_WORD

	EL_SHARED_UNINSTALL_TEXTS

	EL_APPLICATION_CONSTANTS

create
	make

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		require else
			has_main_application: Application_list.has_main
		local
			user_agreed: BOOLEAN
		do
			lio.put_string (Confirmation_prompt + ": ")
			user_agreed := User_input.entered_letter (Word.first_letter_yes)
			lio.put_new_line
			if user_agreed then
				across System.user_permutation_list (Directory.app_all_list) as list loop
					remove_directory (list.item)
				end
			end
		end

feature {NONE} -- Implementation

	remove_directory (path: DIR_PATH)
		-- remove existing directory and one above if it's empty and matches company name
		-- 	.config/<company name>
		-- 	.<company name>
		local
			parent_base: ZSTRING
		do
			OS.delete_tree (path)
			if attached path.parent as parent then
				parent_base := parent.base; parent_base.prune_all_leading ('.')
				if parent_base ~ Build_info.company and then OS_directory.named (parent).is_empty then
					OS.delete_tree (parent)
				end
			end
		end

feature {EL_UNINSTALL_SCRIPT_I} -- String constants

	Confirmation_prompt: ZSTRING
		once
			Result := Text.remove_all_data_prompt #$ [Application_list.Main_launcher.name]
		end

feature {NONE} -- Application constants

	Description: ZSTRING
		once
			Result := Text.remove_all_data_prompt.substring_to ('(')
			Result.right_adjust
		end

	Option_name: IMMUTABLE_STRING_8
		once
			Result := Standard_option.remove_data
		end

end
note
	description: "[
		Standard application to prompt user to remove (current) application data and configuration files
		directories for all users. Usually called from DEBIAN/prerm script with root permissions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-02 11:50:15 GMT (Monday 2nd August 2021)"
	revision: "5"

class
	EL_STANDARD_REMOVE_DATA_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name
		end

	EL_MODULE_COMMAND
	EL_MODULE_DEFERRED_LOCALE
	EL_MODULE_OS
	EL_MODULE_USER_INPUT

	EL_SHARED_APPLICATION_LIST
		export
			{ANY} Application_list
		end

	EL_SHARED_DIRECTORY
		rename
			Directory as OS_directory
		end

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
			user_agreed := User_input.entered_letter (yes.to_latin_1 [1])
			lio.put_new_line
			if user_agreed then
				command.new_user_info.do_for_existing_directories (agent remove_directory)
			end
		end

feature {NONE} -- Implementation

	remove_directory (path: EL_DIR_PATH)
		-- remove existing directory and one above if it's empty and matches company name
		-- 	.config/<company name>
		-- 	.<company name>
		local
			parent: EL_DIR_PATH; parent_base: ZSTRING
		do
			OS.delete_tree (path); parent := path.parent
			parent_base := parent.base.twin; parent_base.prune_all_leading ('.')
			if parent_base ~ Build_info.company_name and then OS_directory.named (parent).is_empty then
				OS.delete_tree (parent)
			end
		end

feature {EL_UNINSTALL_SCRIPT_I} -- String constants

	Confirmation_prompt: ZSTRING
		local
			template: ZSTRING
		once
			if Locale.english_only then
				Locale.set_next_translation ("Delete data and configuration files for all %S users (y/n)")
			end
			template := Locale * "{remove-all-data-prompt}"
			Result := template #$ [Application_list.Main_launcher.name]
		end

	Yes: ZSTRING
		once
			Result := Locale * "yes"
		end

feature {NONE} -- Application constants

	Description: ZSTRING
		local
			pos_bracket: INTEGER
		once
			pos_bracket := Confirmation_prompt.last_index_of ('(', Confirmation_prompt.count)
			if pos_bracket > 0 then
				Result := Confirmation_prompt.substring (1, pos_bracket - 1)
			else
				Result := Confirmation_prompt
			end
		end

	Option_name: STRING
		once
			Result := Application_option.Sub_app.remove_data
		end

end
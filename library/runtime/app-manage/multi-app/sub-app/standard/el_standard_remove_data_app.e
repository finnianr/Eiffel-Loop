note
	description: "[
		Standard application to prompt user to remove data and configuration file directories for all users.
		Usually called from DEBIAN/prerm script with root permissions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 13:01:00 GMT (Sunday 24th November 2019)"
	revision: "1"

class
	EL_STANDARD_REMOVE_DATA_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name
		end

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	EL_MODULE_DEFERRED_LOCALE

	EL_SHARED_APPLICATION_LIST
		export
			{ANY} Application_list
		end

	EL_MODULE_COMMAND

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
				command.new_user_info.do_for_existing_directories (agent OS.delete_tree)
			end
		end

feature {EL_UNINSTALL_SCRIPT_I} -- String constants

	Confirmation_prompt: ZSTRING
		local
			template: ZSTRING
		once
			Locale.set_next_translation ("Delete data and configuration files for all %S users (y/n)")
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
			Result := {EL_COMMAND_OPTIONS}.Remove_data
		end

end

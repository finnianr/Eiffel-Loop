note
	description: "[
		Unix implementation of [$source EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I] interface
		Installer for GNOME desktop. Creates Nautilus script program launcher.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:20:27 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP

inherit
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I

	EL_APPLICATION_INSTALLER_IMP
		rename
			command_args_template as launch_script_template,
			command_args as script_args
		undefine
			application_command, getter_function_table
		end

create
	make

feature {NONE} -- Constants

	Launch_script_location: EL_DIR_PATH
		once
			Result := ".gnome2/nautilus-scripts"
		end

	Launch_script_template: STRING =
		-- Substitution template

		--| Despite appearances the tab level is 0
		--| All leading tabs are removed by Eiffel compiler to match the first line
	"[
		#!/bin/sh
		
		#if $has_path_argument then
		for FILE_PATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
		do
			PATH_ARG=$FILE_PATH
		done
		#end
		
		#if $has_path_argument then
			gnome-terminal --command="$executable_name -$sub_application_option $command_options -$input_path_option_name $PATH_ARG" \
				--geometry 140x50+100+100 --title="$title" \
				--working-directory "$working_directory"
		#else
			gnome-terminal --command="$executable_name -$sub_application_option $command_options" \
				--geometry 140x50+100+100 --title="$title" \
				--working-directory "$working_directory"
		#end
	]"


end

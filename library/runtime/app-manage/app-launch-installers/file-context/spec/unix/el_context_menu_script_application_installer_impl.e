note
	description: "[
		Unix installer for GNOME desktop. Creates Nautilus script program launcher.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 6:45:44 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMPL

inherit
	EL_PLATFORM_IMPL

feature {EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER} -- Constants

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

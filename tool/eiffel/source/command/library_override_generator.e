note
	description: "Creates class overrides of standard libraries for Eiffel-loop"

	other_overrides: "[
		vision2/implementation/gtk/ev_gtk_externals.e (Addition of missing externals)
		
		(Use 15.01 version)
		vision2/implementation/gtk/support/ev_pixel_buffer_imp.e 
		vision2/implementation/mswin/support/ev_pixel_buffer_imp.e
		vision2/implementation/implementation_interface/support/ev_pixel_buffer_i.e
		vision2/interface/support/ev_pixel_buffer.e

		(Use 15.01. Changes for rotated text no longer needed.)
		vision2/implementation/mswin/properties/ev_drawable_imp.e
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 7:22:11 GMT (Friday 8th July 2016)"
	revision: "1"

class
	LIBRARY_OVERRIDE_GENERATOR

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

	EL_FACTORY_CLIENT

feature -- Initialization

	make (ise_eiffel_dir, a_output_dir: like output_dir)
		do
			ise_library_dir := ise_eiffel_dir.joined_dir_path ("library")
			output_dir := a_output_dir
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			File_system.make_directory (output_dir)
			across Editor_factory.alias_names as relative_path loop
				override (relative_path.item)
			end
			log.exit
		end

feature {NONE} -- Implementation

	override (relative_path: EL_FILE_PATH)
		local
			editor: FEATURE_EDITOR; source_path, output_path: EL_FILE_PATH
		do
			source_path := ise_library_dir + relative_path
			output_path := output_dir + relative_path
			if source_path.exists then
				lio.put_path_field ("Editing", relative_path)
				editor := editor_factory.instance_from_alias (
					relative_path.as_string_32, agent {OVERRIDE_FEATURE_EDITOR}.make (source_path)
				)
				File_system.make_directory (output_path.parent)
				editor.write_edited_lines (output_path)
			else
				lio.put_line ("ERROR: source file missing")
				lio.put_path_field ("Source", source_path)
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	ise_library_dir: EL_DIR_PATH

	output_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Editor_factory: EL_OBJECT_FACTORY [OVERRIDE_FEATURE_EDITOR]
		once
			create Result
			-- Web browser GTK
			Result.put (
				{EV_WEB_BROWSER_IMP_FEATURE_EDITOR}, "web_browser/implementation/gtk/ev_web_browser_imp.e"
			)
			-- Docking common
			Result.put (
				{SD_SHARED_EIFFEL_FEATURE_EDITOR}, "docking/implementation/common/sd_shared.e"
			)
			Result.put (
				{SD_ZONE_NAVIGATION_DIALOG_FEATURE_EDITOR}, "docking/implementation/controls/sd_zone_navigation_dialog.e"
			)
			-- Vision2 common
			Result.put (
				{EV_ENVIRONMENT_I_FEATURE_EDITOR}, "vision2/implementation/implementation_interface/kernel/ev_environment_i.e"
			)
			-- Vision2 mswin
			Result.put (
				{EV_PIXMAP_IMP_EIFFEL_FEATURE_EDITOR},
				"vision2/implementation/mswin/widgets/primitives/ev_pixmap_imp.e"
			)
			Result.put (
				{EV_INTERNALLY_PROCESSED_TEXTABLE_IMP_FEATURE_EDITOR},
				"vision2/implementation/mswin/properties/ev_internally_processed_textable_imp.e"
			)
			Result.put (
				{EV_RADIO_BUTTON_IMP_EIFFEL_FEATURE_EDITOR},
				"vision2/implementation/mswin/widgets/primitives/ev_radio_button_imp.e"
			)
			Result.put (
				{EV_PIXMAP_IMP_DRAWABLE_EIFFEL_FEATURE_EDITOR},
				"vision2/implementation/mswin/widgets/primitives/ev_pixmap_imp_drawable.e"
			)
		end


end

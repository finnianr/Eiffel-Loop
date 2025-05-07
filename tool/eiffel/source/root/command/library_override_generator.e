note
	description: "Creates class overrides of standard libraries for Eiffel-loop"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 17:55:37 GMT (Wednesday 7th May 2025)"
	revision: "12"

class
	LIBRARY_OVERRIDE_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_SHARED_FACTORIES

feature -- Initialization

	make (a_output_dir: like output_dir; a_dry_run: BOOLEAN)
		do
			output_dir := a_output_dir; dry_run := a_dry_run
		end

feature -- Constants

	Description: STRING = "Generates overrides of ISE libaries to work with Eiffel-Loop"

feature -- Basic operations

	execute
		do
			File_system.make_directory (output_dir)
			across editor_type_list as list loop
				if attached {OVERRIDE_FEATURE_EDITOR} Makeable_factory.new_item_from_type (list.item) as editor then
					write_override (editor)
				end
			end
		end

feature {NONE} -- Implementation

	editor_types: TUPLE [
		EV_INTERNALLY_PROCESSED_TEXTABLE_IMP_CLASS,
		EV_PIXMAP_IMP_CLASS,
		EV_PIXMAP_IMP_DRAWABLE_CLASS,
		EV_RADIO_BUTTON_IMP_CLASS,
		EV_WEB_BROWSER_IMP_CLASS,
		SD_SHARED_CLASS,
		SD_ZONE_NAVIGATION_DIALOG_CLASS
	]
		do
			create Result
		end

	editor_type_list: EL_TUPLE_TYPE_LIST [OVERRIDE_FEATURE_EDITOR]
		do
			create Result.make_from_tuple (editor_types)
		end

	write_override (editor: OVERRIDE_FEATURE_EDITOR)
		local
			relative_path: FILE_PATH
		do
			relative_path := editor.relative_source_path
			if editor.source_path.exists then
				editor.set_output_path (output_dir + relative_path)
				editor.dry_run.set_state (dry_run)
				editor.execute
			else
				lio.put_line ("ERROR: source file missing")
				lio.put_path_field ("Source", editor.source_path)
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	dry_run: BOOLEAN

	output_dir: DIR_PATH;

note
	notes: "[
		vision2/implementation/gtk/ev_gtk_externals.e (Addition of missing externals)

		(Use 15.01 version)
		vision2/implementation/gtk/support/ev_pixel_buffer_imp.e
		vision2/implementation/mswin/support/ev_pixel_buffer_imp.e
		vision2/implementation/implementation_interface/support/ev_pixel_buffer_i.e
		vision2/interface/support/ev_pixel_buffer.e

		(Use 15.01. Changes for rotated text no longer needed.)
		vision2/implementation/mswin/properties/ev_drawable_imp.e
	]"

end
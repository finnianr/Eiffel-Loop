note
	description: "Creates class overrides of standard libraries for Eiffel-loop"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 8:21:42 GMT (Thursday 8th May 2025)"
	revision: "13"

class
	LIBRARY_OVERRIDE_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

	EL_SHARED_FACTORIES

create
	make

feature -- Initialization

	make (a_output_dir: like output_dir; a_dry_run: BOOLEAN)
		do
			output_dir := a_output_dir; dry_run := a_dry_run
			create changed_class_list.make_empty
		end

feature -- Constants

	Description: STRING = "Generates overrides of ISE libaries to work with Eiffel-Loop"

feature -- Access

	changed_class_list: EL_ARRAYED_LIST [OVERRIDE_FEATURE_EDITOR]

feature -- Basic operations

	execute
		do
			File_system.make_directory (output_dir)
			changed_class_list.wipe_out
			across editor_type_list as list loop
				if attached {OVERRIDE_FEATURE_EDITOR} Makeable_factory.new_item_from_type (list.item) as editor then
					write_override (editor)
				end
			end
		end

feature {NONE} -- Implementation

	editor_type_list: EL_TUPLE_TYPE_LIST [OVERRIDE_FEATURE_EDITOR]
		do
			create Result.make_from_tuple (editor_types)
		end

	editor_types: TUPLE [
		EV_ENVIRONMENT_I_CLASS,
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

	write_override (editor: OVERRIDE_FEATURE_EDITOR)
		local
			relative_path: FILE_PATH
		do
			relative_path := editor.relative_source_path
			if editor.source_path.exists then
				editor.set_output_dir (output_dir)
				editor.dry_run.set_state (dry_run)
				if not dry_run then
					lio.put_path_field ("Generating", relative_path)
					lio.put_new_line
				end
				editor.execute
				if not dry_run and then (not editor.output_path.exists or editor.has_changed) then
					changed_class_list.extend (editor)
				end
			else
				lio.put_line ("ERROR: source file missing")
				lio.put_path_field ("Source", editor.source_path)
				lio.put_new_line
			end
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
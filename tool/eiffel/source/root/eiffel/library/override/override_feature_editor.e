note
	description: "Creates new version of ISE class with auto-edited overrides and fixes"
	notes: "[
		Name the editor class as the name of the class to be edited plus the suffix `_CLASS'.
		For example class ${EV_ENVIRONMENT_I} is edited by ${EV_ENVIRONMENT_I_CLASS}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:50:11 GMT (Friday 18th December 2015)"
	revision: "1"

deferred class
	OVERRIDE_FEATURE_EDITOR

inherit
	FEATURE_EDITOR_COMMAND
		rename
			make as make_editor
		export
			{ANY} source_path
		redefine
			edit_feature_group, make_editor, write_edited_lines
		end

	EL_FILE_GENERATOR

	EL_MODULE_FILE_SYSTEM; EL_MODULE_NAMING

	EL_MAKEABLE

	EL_EIFFEL_CONSTANTS

feature {EL_FACTORY_CLIENT} -- Initialization

	make
		do
			make_editor (Ise_library_path + relative_source_path, False)
		end

	make_editor (a_source_path: FILE_PATH; a_dry_run: BOOLEAN)
		do
			Precursor (a_source_path, a_dry_run)
			feature_edit_actions := new_feature_edit_actions
			create output_dir
		end

feature -- Access

	output_path: FILE_PATH
		do
			Result := output_dir + relative_source_path
		end

	relative_source_path: FILE_PATH
		-- source path relative to $ISE_LIBRARY/library
		do
			Result := dir_path + Naming.class_as_snake_lower (Current, 0, 1)
			Result.add_extension (E_extension)
		end

feature -- Element change

	set_output_dir (a_output_dir: DIR_PATH)
		do
			output_dir := a_output_dir
		end

feature {NONE} -- Implementation

	dir_path: DIR_PATH
		-- original ISE location
		deferred
		end

	do_edit
		do
		end

	edit_feature_group (feature_list: EL_ARRAYED_LIST [CLASS_FEATURE])
		do
			across feature_list as l_feature loop
				feature_edit_actions.search (l_feature.item.name)
				if feature_edit_actions.found then
					feature_edit_actions.found_item.call ([l_feature.item])
				end
			end
		end

	write_edited_lines (a_output_path: FILE_PATH)
		do
			if output_dir.exists and then attached output_path as path then
				do_edit
				File_system.make_directory (path.parent)
				Precursor (path)
			end
		end

feature {NONE} -- Factory

	new_feature_edit_actions: like feature_edit_actions
		deferred
		end

	new_feature_group (export_list, name: ZSTRING): FEATURE_GROUP
		local
			header: EDITABLE_SOURCE_LINES; sg: EL_STRING_GENERAL_ROUTINES
		do
			create header.make (3)
			if export_list.is_empty then
				header.extend (sg.ZSTRING ("feature -- ") + name)
			else
				header.extend (Feature_header_export #$ [export_list] + name)
			end
			header.extend ("-- AUTO EDITION: new feature group")
			header.extend ("")
			create Result.make (header, class_name, name)
		end

feature {NONE} -- Internal attributes

	feature_edit_actions: EL_ZSTRING_HASH_TABLE [PROCEDURE [CLASS_FEATURE]]

	output_dir: DIR_PATH

feature {NONE} -- Constants

	Feature_header_export: EL_ZSTRING
		once
			Result := "feature {%S} -- "
		end

	ISE_library_path: DIR_PATH
		once
			create Result.make_expanded ("$ISE_LIBRARY/library")
		end

invariant
	correctly_named: generator.ends_with ("_CLASS")
end

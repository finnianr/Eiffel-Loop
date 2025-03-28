note
	description: "Backup mirroring configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:40:54 GMT (Friday 28th March 2025)"
	revision: "15"

deferred class
	EL_MIRROR_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			make_default as make,
			xml_naming as eiffel_naming
		end

	EL_FALLIBLE undefine is_equal end

	EL_MODULE_LIO; EL_MODULE_NAMING; EL_MODULE_USER_INPUT

feature -- Access

	backup_dir: DIR_PATH

	protocol: STRING
		do
			Result := Naming.class_as_snake_lower (Current, 1, 2)
		end

	to_string: ZSTRING
		deferred
		end

feature -- Status query

	is_mounted: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	authenticate
		do
		end

	transfer (backup_target_dir: DIR_PATH)
		do
			if attached new_command (backup_target_dir) as cmd then
				cmd.set_source_path (backup_target_dir)
				cmd.execute
				if cmd.has_error then
					error_list.append (cmd.error_list)
				else
					reset
				end
			end
		end

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_MIRROR_TREE_COMMAND_I
		deferred
		end
end
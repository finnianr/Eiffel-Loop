note
	description: "[
		A ${EL_OS_COMMAND} with arguments parsed and set in the attribute **var** with type
		defined as a class parameter
	]"
	notes: "[
		The names in **VARIABLES** type must occur in the same order as they do in the **template**
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-21 16:17:05 GMT (Tuesday 21st January 2025)"
	revision: "15"

class
	EL_PARSED_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_OS_COMMAND
		rename
			make as make_command,
			Var as Standard_var
		export
			{EL_FALLIBLE} error_list
		redefine
			default_name, execute, make_default, make_command
		end

create
	make_command

feature {NONE} -- Initialization

	make
		require
			has_template: default_template.count > 0
		do
			make_command (default_template)
		end

	make_command (a_template: READABLE_STRING_GENERAL)
		do
			Precursor (a_template)
			fill_variables (variables)
		end

	make_default
		do
			Precursor
			create variables
		end

feature -- Access

	variables: VARIABLES

	var: like variables
		do
			Result := variables
		end

feature -- Basic operations

	execute
		require else
			all_variables_set: all_variables_set
		do
			Precursor
		end

feature -- Status query

	all_variables_set: BOOLEAN
		local
			var_name, substituted: STRING
		do
			create var_name.make_filled ('$', 1)
			substituted := template.substituted
			Result := True
			across name_list as name until not Result loop
				var_name.keep_head (1)
				var_name.append (name.item)
				if substituted.has_substring (var_name) then
					Result := False
				end
			end
		end

feature {NONE} -- Implementation

	default_name (a_template: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := generator
			Result.to_lower
		end

	default_template: READABLE_STRING_GENERAL
		do
			create {STRING_8} Result.make_empty
		end

	name_list: EL_STRING_8_LIST
		local
			i: INTEGER
		do
			create Result.make (var.count)
			from i := 1 until i > var.count loop
				if attached {STRING} var.reference_item (i) as name then
					Result.extend (name)
				end
				i := i + 1
			end
		ensure
			list_is_full: Result.count = var.count
		end

	put_path_variable (index: INTEGER; a_path: EL_PATH)
		do
			if index.to_boolean then
				put_path (variable (index), a_path)
			end
		end

	put_string_variable (index: INTEGER; value: READABLE_STRING_GENERAL)
		do
			if index.to_boolean then
				put_string (variable (index), value)
			end
		end

	valid_variable_names: BOOLEAN
		local
			pos: INTEGER; var_name: STRING
			l_template: like default_template
		do
			create var_name.make_filled ('$', 1)
			l_template := default_template
			Result := True
			across name_list as name until not Result loop
				var_name.keep_head (1)
				var_name.append (name.item)
				pos := l_template.substring_index (var_name, pos + 1)
				if pos > 0 then
					pos := pos + var_name.count - 1
				else
					Result := False
				end
			end
		end

	variable (index: INTEGER): STRING
		do
			if index > 0 and then var.valid_index (index)
				and then attached {STRING} var.reference_item (index) as name
			then
				Result := name
			else
				create Result.make_empty
			end
		end

note
	descendants: "[
			EL_PARSED_OS_COMMAND [VARIABLES -> ${TUPLE} create default_create end]
				${EL_SSH_DIRECTORY_COMMAND*}
					${EL_SSH_MAKE_DIRECTORY_COMMAND}
					${EL_SSH_TEST_DIRECTORY_COMMAND}
				${EL_FILE_UTILITY_COMMAND}
				${EL_MIRROR_COMMAND* [VARIABLES -> TUPLE create default_create end]}
					${EL_FILE_RSYNC_COMMAND}
					${EL_FTP_MIRROR_COMMAND}
					${EL_SSH_RSYNC_COMMAND}
				${EL_APPLY_PATCH_COMMAND}
				${EL_GENERATE_PATCH_COMMAND}
				${EL_CREATE_TAR_COMMAND}
				${EL_GUNZIP_COMMAND}
				${EL_SSH_COPY_COMMAND}
				${EL_PARSED_CAPTURED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
					${EL_GVFS_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
						${EL_GVFS_URI_COMMAND*}
							${EL_GVFS_REMOVE_FILE_COMMAND}
							${EL_GVFS_FILE_LIST_COMMAND}
							${EL_GVFS_FILE_INFO_COMMAND}
							${EL_GVFS_FILE_COUNT_COMMAND}
							${EL_GVFS_FILE_EXISTS_COMMAND}
							${EL_GVFS_MAKE_DIRECTORY_COMMAND}
						${EL_GVFS_URI_TRANSFER_COMMAND*}
							${EL_GVFS_COPY_COMMAND}
							${EL_GVFS_MOVE_COMMAND}
						${EL_GVFS_MOUNT_LIST_COMMAND}
					${EL_SYMLINK_LISTING_COMMAND}
					${EL_GET_GNOME_SETTING_COMMAND}
				${EL_SSH_MD5_HASH_COMMAND}
				${EL_SET_GNOME_SETTING_COMMAND}
				${EL_NOTIFY_SEND_ERROR_COMMAND_I*}
					${EL_NOTIFY_SEND_ERROR_COMMAND}
	]"

end
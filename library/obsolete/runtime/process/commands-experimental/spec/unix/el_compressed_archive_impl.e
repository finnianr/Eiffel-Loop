note
	description: "Summary description for {EL_CREATE_COMPRESSED_TAR_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_COMPRESSED_ARCHIVE_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("tar")
		end

feature -- Basic operations

	set_arguments (command: EL_COMPRESSED_ARCHIVE_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)

			-- tar --create --auto-compress --dereference --file="$TAR_NAME" "$TARGET_DIRECTORY" \
			-- --exclude-from=$TAR_EXCLUDE --files-from=$TAR_INCLUDE
		do
			arguments.set_command_option_prefix ("--")

			arguments.add_options_list ("create auto-compress dereference")

			arguments.add_path_option ("file=", command.archive_path)
			arguments.add_path (command.source_path)

			if not command.exclusion_list_path.is_empty then
				arguments.add_path_option ("exclude-from=", command.exclusion_list_path)
			end
			if not command.inclusion_list_path.is_empty then
				arguments.add_path_option ("files-from=", command.inclusion_list_path)
			end
		end
end

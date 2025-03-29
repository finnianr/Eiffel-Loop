note
	description: "Operating system command interface"
	notes: "[
		**Routine getter_functions table**

		This routine automatically adds the following field types to the `getter_functions' table
		so they can be referenced in the Evolicity template string.

		1. ${EL_BOOLEAN_OPTION} will be added with the modified name: `<field-name>_enabled'

		2. Any field conforming to ${EL_PATH} will be added using the agent function `get_escaped_path'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:05:51 GMT (Saturday 29th March 2025)"
	revision: "73"

deferred class
	EL_OS_COMMAND_I

inherit
	EL_OS_COMMAND_BASE_I
		export
			{EL_OS_COMMAND_I} new_temporary_file_path
		redefine
			context_item, make_default
		end

	EL_FALLIBLE
		rename
			put as put_error,
			print_errors as print_all_errors
		export
			{NONE} all
			{EL_FALLIBLE} error_list
		redefine
			has_error, reset
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			output_encoding := Utf_8
			create dry_run
		end

feature -- Access

	effective_working_directory: DIR_PATH
		-- working directory for execution of the command
		do
			if working_directory.is_empty then
				Result := Directory.current_working
			else
				Result := working_directory
			end
		end

	output_encoding: NATURAL

	success_code: INTEGER
		-- exit code that indicates command ran without error
		-- default is 0

	working_directory: DIR_PATH
		-- temporary working directory used only for the command execution

feature -- Status query

	administrator: EL_BOOLEAN_OPTION
		-- if option is enabled allows a permitted user to execute a command as the superuser
		-- on Unix or Administrator on Windows platform
		do
			Result := sudo
		end

	back_quotes_escaped: BOOLEAN
			-- If true, back quote characters ` are escaped on posix platforms
			-- This means that commands that use BASH back-quote command substitution cannot be used
			-- without first making sure that individual path operands are escaped
		do
			Result := not {PLATFORM}.is_windows
		end

	dry_run: EL_BOOLEAN_OPTION
		-- when `true' command will just print to screen without executing

	has_error: BOOLEAN
		-- True if the command returned an error code on exit

	is_captured: BOOLEAN
		-- `True' if command output is being captured
		do
			do_nothing
		end

	is_forked: BOOLEAN
		-- `true' if command executes asynchronously in another system process

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

	sudo: EL_BOOLEAN_OPTION
		-- if option is enabled allows a permitted user to execute a command as the superuser
		-- on Unix or Administrator on Windows platform

feature -- Element change

	set_output_encoding (a_output_encoding: NATURAL)
		do
			output_encoding := a_output_encoding
		end

	set_success_code (a_code: INTEGER)
		do
			success_code := a_code
		end

	set_working_directory (a_working_directory: DIR_PATH)
		-- set a temporary working directory used only for the command execution
		do
			working_directory := a_working_directory
		end

feature -- Status change

	set_forking_mode (forked: BOOLEAN)
		-- when `forked' is `True', execution happens in another process
		require
			no_capture: not is_captured
		do
			is_forked := forked
		end

feature -- Basic operations

	execute
			--
		require else
			valid_platform: is_valid_platform
		do
			reset
			if attached system_command as l_command then
				if l_command.is_empty then
					lio.put_string_field ("Error in command template", generator)
					lio.put_new_line
				else
					if dry_run.is_enabled or else is_lio_enabled then
						display (l_command.lines)
					end
					if dry_run.is_disabled then
						l_command.translate_or_delete (Tab_and_new_line, Null_and_space)
						do_command (l_command)
					end
				end
			end
		end

	print_error (a_description: detachable READABLE_STRING_GENERAL)
		local
			description: READABLE_STRING_GENERAL
		do
			if attached error_list as list then
				lio.put_new_line
				if attached a_description as str then
					description := str
				else
					description := generator
				end
				lio.put_labeled_string ("ERROR", description)
				lio.put_new_line
				list.first.print_to (lio)
			end
		end

feature {NONE} -- Implementation

	context_item (variable_ref: EVC_VARIABLE_REFERENCE; index: INTEGER): ANY
		do
			if attached variable_ref [index] as key then
				if getter_functions.has_key (key) then
					Result := getter_functions.found_item_result (Current, variable_ref, index)

				elseif field_table.has_key (key) then
					Result := field_value (field_table.found_item)

				elseif key.same_caseless_characters (Var_current, 1, Var_current.count, 1) then
					Result := Current
				else
					Result := Undefined_template #$ [variable_ref.out]
				end
			end
		end

	do_command (a_system_command: like system_command)
		local
			command_parts: EL_ZSTRING_LIST; error_path: FILE_PATH; working_dir: DIR_PATH
		do
			working_dir := working_directory
			if not working_dir.is_empty then
				Execution_environment.push_current_working (working_dir)
			end
			create command_parts.make_from_array (new_command_parts (a_system_command))
			if {PLATFORM}.is_unix and then sudo.is_enabled then
				command_parts.put_front (Sudo_command)
			end
			command_parts.prune_all_empty -- `command_prefix' is empty on Unix

			if is_forked then
				Execution_environment.launch (command_parts.as_word_string)

				if not working_dir.is_empty then
					Execution_environment.pop_current_working
				end
			else
				error_path := temporary_error_file_path
				File_system_mutex.lock
					File_system.make_directory (error_path.parent)
				File_system_mutex.unlock

				if {PLATFORM}.is_windows and then administrator.is_enabled then
					run_as_administrator (command_parts)
				else
					Execution_environment.system (command_parts.as_word_string)
					set_has_error (Execution_environment.return_code)
				end

				if not working_dir.is_empty then
					Execution_environment.pop_current_working
				end
				if has_error and then attached new_error as error then
					if error_path.exists then
						error.set_list (new_output_lines (error_path).as_list)
					end
					put_error (error); on_error (error)
				end
				File_system_mutex.lock
					if error_path.exists then
						File_system.remove_file (error_path)
					end
				File_system_mutex.unlock
			end
		end

	reset
		-- Executed before do_command
		do
			Precursor
			has_error := False
		end

	set_has_error (return_code: INTEGER)
		do
			has_error := return_code /= success_code
		end

	temporary_error_file_path: FILE_PATH
		do
			Result := Temporary_error_path_by_type.item (Current)
		end

feature {EL_OS_COMMAND_I} -- Factory

	new_command_parts (a_system_command: like system_command): ARRAY [ZSTRING]
		do
			if is_forked then
				Result := << command_prefix, a_system_command, Null_redirection >>
			else
				Result := <<
					command_prefix, a_system_command, Error_redirection_operator, temporary_error_file_path
				>>
			end
		end

feature {NONE} -- Constants

	Temporary_error_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_OS_COMMAND_I, FILE_PATH]
		once
			create Result.make (17, agent {EL_OS_COMMAND_I}.new_temporary_file_path ("err"))
		end

note
	descendants: "[
			EL_OS_COMMAND_I*
				${EL_OS_COMMAND_IMP*}
					${EL_COPY_TREE_COMMAND_IMP}
					${EL_VIDEO_TO_MP3_COMMAND_IMP}
					${EL_COPY_FILE_COMMAND_IMP}
					${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP}
					${EL_AUDIO_PROPERTIES_COMMAND_IMP}
					${EL_WAV_FADER_IMP}
					${EL_WAV_GENERATION_COMMAND_IMP}
					${EL_WAV_TO_MP3_COMMAND_IMP}
					${EL_CREATE_LINK_COMMAND_IMP}
					${EL_MOVE_FILE_COMMAND_IMP}
					${EL_MOVE_TO_DIRECTORY_COMMAND_IMP}
					${EL_OS_COMMAND}
						${EL_PARSED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
							${EL_PARSED_CAPTURED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
								${EL_GVFS_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
									${EL_GVFS_MOUNT_LIST_COMMAND}
									${EL_GVFS_URI_TRANSFER_COMMAND*}
										${EL_GVFS_COPY_COMMAND}
										${EL_GVFS_MOVE_COMMAND}
									${EL_GVFS_URI_COMMAND*}
										${EL_GVFS_MAKE_DIRECTORY_COMMAND}
										${EL_GVFS_REMOVE_FILE_COMMAND}
										${EL_GVFS_FILE_LIST_COMMAND}
										${EL_GVFS_FILE_INFO_COMMAND}
										${EL_GVFS_FILE_COUNT_COMMAND}
										${EL_GVFS_FILE_EXISTS_COMMAND}
								${EL_GET_GNOME_SETTING_COMMAND}
								${EL_SYMLINK_LISTING_COMMAND}
							${EL_CREATE_TAR_COMMAND}
							${EL_FILE_UTILITY_COMMAND}
							${EL_SSH_COPY_COMMAND}
							${EL_SSH_MD5_HASH_COMMAND}
							${EL_SSH_DIRECTORY_COMMAND*}
								${EL_SSH_TEST_DIRECTORY_COMMAND}
								${EL_SSH_MAKE_DIRECTORY_COMMAND}
							${EL_MIRROR_COMMAND* [VARIABLES -> TUPLE create default_create end]}
								${EL_FTP_MIRROR_COMMAND}
								${EL_SSH_RSYNC_COMMAND}
								${EL_FILE_RSYNC_COMMAND}
						${EL_CAPTURED_OS_COMMAND}
							${EL_PARSED_CAPTURED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
							${EL_MD5_HASH_COMMAND}
								${EL_SSH_MD5_HASH_COMMAND}
					${EL_DELETE_FILE_COMMAND_IMP}
					${EL_DELETE_TREE_COMMAND_IMP}
					${EL_RSYNC_COMMAND_IMP}
					${EL_MAKE_DIRECTORY_COMMAND_IMP}
					${EL_CAPTURED_OS_COMMAND_IMP*}
						${EL_NETWORK_DEVICE_LIST_IMP}
						${EL_CPU_INFO_COMMAND_IMP}
						${EL_EXTRACT_MP3_INFO_COMMAND_IMP}
						${EL_USERS_INFO_COMMAND_IMP}
						${EL_FIND_COMMAND_IMP*}
							${EL_FIND_DIRECTORIES_COMMAND_IMP}
							${EL_FIND_FILES_COMMAND_IMP}
						${EL_X509_PRIVATE_READER_COMMAND_IMP}
						${EL_X509_PUBLIC_READER_COMMAND_IMP}
						${EL_SEND_MAIL_COMMAND_IMP}
						${EL_DIRECTORY_INFO_COMMAND_IMP}
						${EL_JPEG_FILE_INFO_COMMAND_IMP}
				${EL_CAPTURED_OS_COMMAND_I*}
					${EL_FIND_COMMAND_I*}
						${EL_FIND_DIRECTORIES_COMMAND_I*}
							${EL_FIND_DIRECTORIES_COMMAND_IMP}
						${EL_FIND_FILES_COMMAND_I*}
							${EL_FIND_FILES_COMMAND_IMP}
					${EL_CPU_INFO_COMMAND_I*}
						${EL_CPU_INFO_COMMAND_IMP}
					${EL_EXTRACT_MP3_INFO_COMMAND_I*}
						${EL_EXTRACT_MP3_INFO_COMMAND_IMP}
					${EL_X509_CERTIFICATE_READER_COMMAND_I*}
						${EL_X509_PRIVATE_READER_COMMAND_I*}
							${EL_X509_PRIVATE_READER_COMMAND_IMP}
						${EL_X509_PUBLIC_READER_COMMAND_I*}
							${EL_X509_PUBLIC_READER_COMMAND_IMP}
					${EL_USERS_INFO_COMMAND_I*}
						${EL_USERS_INFO_COMMAND_IMP}
					${EL_SEND_MAIL_COMMAND_I*}
						${EL_SEND_MAIL_COMMAND_IMP}
					${EL_DIRECTORY_INFO_COMMAND_I*}
						${EL_DIRECTORY_INFO_COMMAND_IMP}
					${EL_JPEG_FILE_INFO_COMMAND_I*}
						${EL_JPEG_FILE_INFO_COMMAND_IMP}
					${EL_CAPTURED_OS_COMMAND}
					${EL_CAPTURED_OS_COMMAND_IMP*}
				${EL_OS_COMMAND}
				${EL_AVCONV_OS_COMMAND_I*}
					${EL_VIDEO_TO_MP3_COMMAND_I*}
						${EL_VIDEO_TO_MP3_COMMAND_IMP}
					${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I*}
						${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP}
					${EL_AUDIO_PROPERTIES_COMMAND_I*}
						${EL_AUDIO_PROPERTIES_COMMAND_IMP}
				${EL_SINGLE_PATH_OPERAND_COMMAND_I*}
					${EL_WAV_GENERATION_COMMAND_I*}
						${EL_WAV_GENERATION_COMMAND_IMP}
					${EL_EXTRACT_MP3_INFO_COMMAND_I*}
					${EL_AUDIO_PROPERTIES_COMMAND_I*}
					${EL_DIR_PATH_OPERAND_COMMAND_I*}
						${EL_FIND_COMMAND_I*}
						${EL_USERS_INFO_COMMAND_I*}
						${EL_DIRECTORY_INFO_COMMAND_I*}
						${EL_DELETE_TREE_COMMAND_I*}
							${EL_DELETE_TREE_COMMAND_IMP}
						${EL_MAKE_DIRECTORY_COMMAND_I*}
							${EL_MAKE_DIRECTORY_COMMAND_IMP}
					${EL_DOUBLE_PATH_OPERAND_COMMAND_I*}
						${EL_CREATE_LINK_COMMAND_I*}
							${EL_CREATE_LINK_COMMAND_IMP}
						${EL_MOVE_TO_DIRECTORY_COMMAND_I*}
							${EL_MOVE_TO_DIRECTORY_COMMAND_IMP}
						${EL_FILE_RELOCATION_COMMAND_I*}
							${EL_COPY_TREE_COMMAND_I*}
								${EL_COPY_TREE_COMMAND_IMP}
								${EL_RSYNC_COMMAND_I*}
									${EL_RSYNC_COMMAND_IMP}
							${EL_COPY_FILE_COMMAND_I*}
								${EL_COPY_FILE_COMMAND_IMP}
							${EL_MOVE_FILE_COMMAND_I*}
								${EL_MOVE_FILE_COMMAND_IMP}
						${EL_FILE_CONVERSION_COMMAND_I*}
							${EL_VIDEO_TO_MP3_COMMAND_I*}
							${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I*}
							${EL_WAV_FADER_I*}
								${EL_WAV_FADER_IMP}
							${EL_WAV_TO_MP3_COMMAND_I*}
								${EL_WAV_TO_MP3_COMMAND_IMP}
					${EL_FILE_PATH_OPERAND_COMMAND_I*}
						${EL_DELETE_FILE_COMMAND_I*}
							${EL_DELETE_FILE_COMMAND_IMP}
						${EL_X509_CERTIFICATE_READER_COMMAND_I*}
	]"
end
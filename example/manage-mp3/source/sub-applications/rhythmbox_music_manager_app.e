note
	description: "Summary description for {RHYTHMBOX_MUSIC_MANAGER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 19:03:09 GMT (Friday 8th July 2016)"
	revision: "5"

class
	RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [RHYTHMBOX_MUSIC_MANAGER]
		rename
			command as music_manager_command
		redefine
			Option_name, set_reference_operand, skip_normal_initialize, initialize
		end

	TASK_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Console.show ({EL_VIDEO_TO_MP3_COMMAND_IMP})
			Precursor
		end

feature -- Testing

	test_music_manager (data_path: EL_DIR_PATH; config: MANAGER_CONFIG)
			--
		do
			log.enter ("test_music_manager")
			if config.task ~ Task_import_videos then
				create {TEST_VIDEO_IMPORT_MUSIC_MANAGER} music_manager_command.make (config)
			else
				create {TEST_MUSIC_MANAGER} music_manager_command.make (config)
			end
			music_manager_command.execute
			log.exit
		end

	test_run
			--
		do
			if not has_invalid_argument then
				Test.set_excluded_file_extensions (<< "mp3", "jpeg" >>)
				if attached {MANAGER_CONFIG} operands.reference_item (1) as config then
					config.dj_events.playlist_dir := "workarea/rhythmdb/Documents/DJ-events"
					Test.do_file_tree_test ("rhythmdb", agent test_music_manager (?, config), config.test_checksum)
				end
			end
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument (Arg_config, "Task configuration file")
			>>
		end

	default_operands: TUPLE [config: MANAGER_CONFIG]
		do
			create Result
			Result.config := create {MANAGER_CONFIG}.make
		end

	make_action: PROCEDURE [like music_manager_command, like default_operands]
		do
			Result := agent music_manager_command.make
		end

	set_reference_operand (a_index: INTEGER; arg_spec: like Type_argument_specification; argument_ref: ANY)
		local
			l_file_path: EL_FILE_PATH
		do
			if attached {MANAGER_CONFIG} argument_ref as config then
				if Args.has_value (arg_spec.word_option) then
					l_file_path := Args.file_path (arg_spec.word_option)
					if l_file_path.exists then
						operands.put_reference (create {MANAGER_CONFIG}.make_from_file (l_file_path), a_index)
					else
						set_path_argument_error (arg_spec.word_option, English_file, l_file_path)
					end
				elseif arg_spec.is_required then
					set_required_argument_error (arg_spec.word_option)
				end
			else
				Precursor (a_index, arg_spec, argument_ref)
			end
		end

	skip_normal_initialize: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Constants

	Arg_config: ZSTRING
		once
			Result := "config"
		end

	Description: STRING = "Manage Rhythmbox Music Collection"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{RHYTHMBOX_MUSIC_MANAGER_APP}, All_routines],
				[{RHYTHMBOX_MUSIC_MANAGER}, All_routines],
				[{TEST_VIDEO_IMPORT_MUSIC_MANAGER}, All_routines],
				[{RBOX_DATABASE}, All_routines],

				[{TEST_MUSIC_MANAGER}, All_routines],
				[{TEST_STORAGE_DEVICE}, All_routines],

				[{STORAGE_DEVICE}, All_routines],
				[{NOKIA_PHONE_DEVICE}, All_routines],
				[{SAMSUNG_TABLET_DEVICE}, All_routines]
			>>
		end

	Option_name: STRING = "manager"

end

note
	description: "Summary description for {RHYTHMBOX_MUSIC_MANAGER_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RHYTHMBOX_MUSIC_MANAGER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [RHYTHMBOX_MUSIC_MANAGER]
		rename
			command as music_manager_command
		redefine
			Option_name, set_reference_operand, skip_normal_normal_initialize
		end

	TASK_CONSTANTS

create
	make

feature -- Testing

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

feature {NONE} -- Implementation

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

	skip_normal_normal_initialize: BOOLEAN
		do
			Result := False
		end

	make_action: PROCEDURE [like music_manager_command, like default_operands]
		do
			Result := agent music_manager_command.make
		end

	default_operands: TUPLE [config: MANAGER_CONFIG]
		do
			create Result
			Result.config := create {MANAGER_CONFIG}.make
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument (Arg_config, "Task configuration file")
			>>
		end

feature {NONE} -- Constants

	Arg_config: ASTRING
		once
			Result := "config"
		end

	Option_name: STRING = "manager"

	Description: STRING = "Manage Rhythmbox Music Collection"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_TEST_ROUTINES}, All_routines],
				[{RHYTHMBOX_MUSIC_MANAGER_APP}, All_routines],
				[{RHYTHMBOX_MUSIC_MANAGER}, All_routines],
				[{TEST_VIDEO_IMPORT_MUSIC_MANAGER}, All_routines],
				[{RBOX_DATABASE}, All_routines],

				[{TEST_MUSIC_MANAGER}, All_routines],
				[{TEST_USB_DEVICE}, All_routines],

				[{USB_DEVICE}, All_routines],
				[{NOKIA_USB_DEVICE}, All_routines],
				[{GALAXY_TABLET_USB_DEVICE}, All_routines]
--				[{EL_WAV_GENERATION_COMMAND}, All_routines],
--				[{EL_WAV_TO_MP3_COMMAND}, All_routines]
			>>
		end

end

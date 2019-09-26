note
	description: "Music manager sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 16:44:32 GMT (Wednesday   25th   September   2019)"
	revision: "1"

class
	MUSIC_MANAGER_SUB_APPLICATION

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [RBOX_MUSIC_MANAGER]
		redefine
			Option_name, Visible_types
		end

	RHYTHMBOX_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Task configuration file",  << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Manage Rhythmbox Music Collection"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{like command}, All_routines],
				[{like command.database}, All_routines],

				[{STORAGE_DEVICE}, All_routines],
				[{NOKIA_PHONE_DEVICE}, All_routines],
				[{SAMSUNG_TABLET_DEVICE}, All_routines],

				[{ADD_ALBUM_ART_TASK}, All_routines],
				[{COLLATE_SONGS_TASK}, All_routines],
				[{DELETE_COMMENTS_TASK}, All_routines],
				[{DISPLAY_INCOMPLETE_ID3_INFO_TASK}, All_routines],
				[{DISPLAY_MUSIC_BRAINZ_INFO_TASK}, All_routines],
				[{EXPORT_MUSIC_TO_DEVICE_TASK}, All_routines],
				[{NORMALIZE_COMMENTS_TASK}, All_routines],
				[{PRINT_COMMENTS_TASK}, All_routines],
				[{PUBLISH_DJ_EVENTS_TASK}, All_routines],
				[{REMOVE_ALL_UFIDS_TASK}, All_routines]
			>>
		end

	Option_name: STRING
		once
			Result := "manager"
		end

	Visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			Result := << {EL_BUILDER_OBJECT_FACTORY [RBOX_MANAGEMENT_TASK]}, {M3U_PLAYLIST_READER} >>
		end

end

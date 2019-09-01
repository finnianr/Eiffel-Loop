note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:40:29 GMT (Sunday 1st September 2019)"
	revision: "6"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{MP3_AUDIO_SIGNATURE_READER_APP},
				{RHYTHMBOX_MUSIC_MANAGER_APP},

--				Obsolete apps
--				{RBOX_IMPORT_NEW_MP3_APP},
--				{RBOX_PLAYLIST_IMPORT_APP},
--				{RBOX_RESTORE_PLAYLISTS_APP},

				{ID3_EDITOR_APP},
				{TANGO_MP3_FILE_COLLATOR_APP},

				{TEST_RHYTHMBOX_MUSIC_MANAGER_APP},
				{TEST_APP}
			>>
		end

end

note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:04 GMT (Tuesday 2nd September 2014)"
	revision: "5"

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
				{RHYTHMBOX_MUSIC_MANAGER_APP},

				{RBOX_IMPORT_NEW_MP3_APP},
				{RBOX_PLAYLIST_IMPORT_APP},
				{RBOX_RESTORE_PLAYLISTS_APP},

				{ID3_EDITOR_APP},
				{MP3_FILE_COLLATOR_APP}
			>>
		end

	notes: PROJECT_NOTES

end

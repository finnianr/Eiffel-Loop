note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-25 8:49:17 GMT (Sunday 25th September 2016)"
	revision: "2"

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

				{RBOX_IMPORT_NEW_MP3_APP}, -- Obsolete
				{RBOX_PLAYLIST_IMPORT_APP}, -- Obsolete
				{RBOX_RESTORE_PLAYLISTS_APP}, -- Obsolete

				{ID3_EDITOR_APP},
				{TANGO_MP3_FILE_COLLATOR_APP}
			>>
		end

	notes: TUPLE [DONE_LIST, TO_DO_LIST]
		do
		end
end

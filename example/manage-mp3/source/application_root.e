note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "3"

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
				{MEDIA_SYNC_APP},

				{RBOX_ADD_ALBUM_PICTURES_APP},
				{RBOX_ARTIST_AND_TITLE_NORMALIZATION_APP},
				{RBOX_COLLATION_BY_GENRE_AND_ARTIST_APP},
				{RBOX_REPLACE_CORTINA_SET_APP},
				{RBOX_DATABASE_EXPORT_APP},

				{RBOX_REPLACE_DELETED_SONGS_APP},

				{RBOX_HTML_PLAYLIST_APP},
				{RBOX_ID3_EDIT_APP},
				{RBOX_IMPORT_NEW_MP3_APP},

				{RBOX_PLAYLIST_EXPORT_APP},
				{RBOX_PLAYLIST_IMPORT_APP},
				{RBOX_RESTORE_PLAYLISTS_APP},
				{RBOX_VIDEO_IMPORT_APP},

				{ID3_EDITOR_APP}
			>>
		end

note
	to_do: "[
		* Add codec support to PLAIN_TEXT_FILE. Solve reading OS output file paths from file by using this
		
		Nov 11, 2013
		
		* Some song integer fields needed for publish playlists have been subsumed into integer list
		
	]"
end

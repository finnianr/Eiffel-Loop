note
	description: "Rhythmbox ignored file entry (used for Pyxis playlists)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "25"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			Type, get_location_uri
		end

create
	make

feature -- Access

	file_path: FILE_PATH
		do
			Result := location.to_file_path
		end

feature {NONE} -- Implemenatation

	get_location_uri: EL_URI
		do
			Result := Database.shortened_file_uri (location)
		end

feature -- Constants

	Type: STRING
		once
			Result := "ignored"
		end

end
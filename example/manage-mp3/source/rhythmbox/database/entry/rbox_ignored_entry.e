note
	description: "Rhythmbox ignored file entry (used for Pyxis playlists)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "24"

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

note
	description: "Rhythmbox ignored file entry (used for Pyxis playlists)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 14:01:19 GMT (Friday 22nd May 2020)"
	revision: "21"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			Type, set_location_from_node, url_encoded_location_uri
		end

create
	make

feature -- Access

	file_path: EL_FILE_PATH
		do
			Result := location_uri.to_file_path
		end

feature {NONE} -- Implemenatation

	set_location_from_node
		do
			set_location_uri (Database.expanded_file_uri (decoded_location (node)))
		end

	url_encoded_location_uri: STRING
		do
			Result := Database.shortened_file_uri (encoded_location_uri (location_uri))
		end

feature -- Constants

	Type: STRING
		once
			Result := "ignored"
		end

end

note
	description: "Rhythmbox ignored file entry (used for Pyxis playlists)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-18 10:54:32 GMT (Monday 18th May 2020)"
	revision: "20"

class
	RBOX_IGNORED_ENTRY

inherit
	RBOX_IRADIO_ENTRY
		redefine
			Protocol, Type
		end

create
	make

feature -- Constants

	Protocol: ZSTRING
		once
			Result := "file"
		end

	Type: STRING
		once
			Result := "ignored"
		end

end

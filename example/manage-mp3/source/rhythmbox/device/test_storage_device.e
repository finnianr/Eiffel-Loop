note
	description: "Test storage device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-26 13:30:15 GMT (Tuesday 26th May 2020)"
	revision: "5"

class
	TEST_STORAGE_DEVICE

inherit
	STORAGE_DEVICE
		redefine
			set_volume
		end

create
	make

feature -- Element change

	set_volume (a_volume: like volume)
		do
			a_volume.set_uri_root (Directory.current_working)
			a_volume.extend_uri_root ("workarea/rhythmdb/TABLET")
			Precursor (a_volume)
		end

end

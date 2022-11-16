note
	description: "Test storage device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
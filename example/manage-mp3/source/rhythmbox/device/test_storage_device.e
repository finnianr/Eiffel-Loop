note
	description: "Test storage device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-15 11:41:14 GMT (Wednesday 15th April 2020)"
	revision: "4"

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
			a_volume.set_uri_root (".")
			a_volume.extend_uri_root ("workarea/rhythmdb/TABLET")
			Precursor (a_volume)
		end

end

note
	description: "Summary description for {TEST_USB_DEVICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-10-04 13:38:42 GMT (Sunday 4th October 2015)"
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
			a_volume.extend_uri_root ("./workarea/rhythmdb/TABLET")
			File_system.make_directory (a_volume.uri_root)
			Precursor (a_volume)
		end

end

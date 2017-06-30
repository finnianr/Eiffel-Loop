note
	description: "Summary description for {TEST_USB_DEVICE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-18 12:35:24 GMT (Sunday 18th June 2017)"
	revision: "2"

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

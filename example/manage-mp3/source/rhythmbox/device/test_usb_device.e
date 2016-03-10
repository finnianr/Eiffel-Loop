note
	description: "Summary description for {TEST_USB_DEVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_USB_DEVICE

inherit
	USB_DEVICE
		redefine
			set_volume
		end

create
	make

feature -- Element change

	set_volume (a_volume: like volume)
		do
			a_volume.set_uri_root ("./workarea/rhythmdb/TABLET")
			File_system.make_directory (a_volume.uri_root)
			Precursor (a_volume)
		end

end

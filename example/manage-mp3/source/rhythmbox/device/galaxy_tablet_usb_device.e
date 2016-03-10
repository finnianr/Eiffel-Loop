note
	description: "Summary description for {GALAXY_TAB_DEVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY_TABLET_USB_DEVICE

inherit
	USB_DEVICE
		redefine
			adjust_genre
		end

create
	make

feature {NONE} -- Implementation

	adjust_genre (id3_info: EL_ID3_INFO)
			-- Galaxy tab players treats the Tango genre in a weird way (don't remember exactly what, displays as Latin or something)
			-- so change to something else here
		do
			if id3_info.genre ~ Genre_tango then
				id3_info.set_genre ("Tango (Classical)")
			end
		end
end

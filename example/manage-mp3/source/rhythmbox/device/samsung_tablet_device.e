note
	description: "Samsung tablet device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 14:59:11 GMT (Tuesday 3rd September 2019)"
	revision: "5"

class
	SAMSUNG_TABLET_DEVICE

inherit
	STORAGE_DEVICE
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
			if id3_info.genre ~ Tango_genre.tango then
				id3_info.set_genre ("Tango (Classical)")
			end
		end
end

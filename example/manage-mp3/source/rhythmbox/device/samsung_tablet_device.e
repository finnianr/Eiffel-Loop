note
	description: "Samsung tablet device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 14:30:57 GMT (Tuesday 24th March 2020)"
	revision: "8"

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

	adjust_genre (id3_info: TL_MPEG_FILE)
			-- Galaxy tab players treats the Tango genre in a weird way (don't remember exactly what, displays as Latin or something)
			-- so change to something else here
		do
			if id3_info.tag.genre ~ Tango_genre.tango then
				id3_info.tag.set_genre ("Tango (Classical)")
			end
		end
end

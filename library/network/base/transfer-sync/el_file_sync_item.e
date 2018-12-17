note
	description: "File synchronization item with CRC-32 checksum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-07 10:24:25 GMT (Friday 7th September 2018)"
	revision: "1"

class
	EL_FILE_SYNC_ITEM

inherit
	EL_CRC_32_SYNC_ITEM
		rename
			make as make_sync
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			file_path := a_file_path
			make_sync
		end

feature -- Access

	file_path: EL_FILE_PATH

feature {NONE} -- Implementation

	sink_content (crc: like crc_generator)
		do
			crc.add_file (file_path)
		end

end

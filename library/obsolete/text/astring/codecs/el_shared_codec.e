note
	description: "Summary description for {EL_SHARED_CODEC}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-04 8:21:09 GMT (Friday 4th December 2015)"
	revision: "1"

deferred class
	EL_SHARED_CODEC

inherit
	EL_SHARED_CELL [EL_CODEC]
		rename
			item as system_codec,
			set_item as set_system_codec,
			cell as Codec_cell
		end

feature {NONE} -- Implementation

	Codec_cell: CELL [EL_CODEC]
		once
			create Result.put (Default_codec)
		end

	Default_codec: EL_CODEC
		once
			create {EL_ISO_8859_15_CODEC} Result.make
		end

end

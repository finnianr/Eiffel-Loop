note
	description: "Defines codec to be used by class [$source EL_ZSTRING] for encoding characters in `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 17:10:40 GMT (Thursday 14th May 2020)"
	revision: "8"

deferred class
	EL_SHARED_ZSTRING_CODEC

inherit
	EL_SHARED_CELL [EL_ZCODEC]
		rename
			item as zstring_codec,
			set_item as set_zstring_codec,
			cell as Codec_cell
		end

	EL_SHARED_ZCODEC_FACTORY

feature {NONE} -- Implementation

	default_codec: EL_ZCODEC
		do
			Result := Codec_factory.zstring_codec
		end

feature {NONE} -- Constants

	Codec: EL_ZCODEC
			-- Working instance
			-- If it needs changing, set the zstring codec first before allowing calls here
		once
			Result := zstring_codec
		end

	Codec_cell: CELL [EL_ZCODEC]
		once
			create Result.put (default_codec)
		end

end

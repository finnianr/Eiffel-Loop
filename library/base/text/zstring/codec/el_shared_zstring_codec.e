note
	description: "Defines codec to be used by class [$source EL_ZSTRING] for encoding characters in `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 11:34:34 GMT (Friday 11th February 2022)"
	revision: "9"

deferred class
	EL_SHARED_ZSTRING_CODEC

inherit
	EL_SHARED_ZCODEC_FACTORY

feature {NONE} -- Implementation

	default_codec: EL_ZCODEC
		do
			Result := Codec_factory.zstring_codec
		ensure
			valid_class: Result.is_windows_encoded or Result.is_latin_encoded
		end

feature {NONE} -- Constants

	Codec: EL_ZCODEC
			-- Working instance
			-- If it needs changing, set the zstring codec first before allowing calls here
		once
			Result := default_codec
		end

end
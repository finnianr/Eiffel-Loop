note
	description: "Defines codec to be used by class [$source EL_ZSTRING] for encoding characters in `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 19:11:56 GMT (Friday 11th February 2022)"
	revision: "10"

deferred class
	EL_SHARED_ZSTRING_CODEC

inherit
	EL_SHARED_ZCODEC_FACTORY

feature {NONE} -- Implementation

	default_codec: EL_ZCODEC
		-- set with command option -zstring_codec
		do
			Result := Codec_factory.zstring_codec
		ensure
			valid_type: Result.is_windows_encoded or Result.is_latin_encoded
		end

feature {NONE} -- Constants

	Codec: EL_ZCODEC
		once
			Result := default_codec
		end

	Unicode_table: SPECIAL [CHARACTER_32]
		once
			Result := Codec.unicode_table
		end

end
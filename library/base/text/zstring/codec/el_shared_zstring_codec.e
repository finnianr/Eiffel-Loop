note
	description: "Defines codec to be used by class ${EL_ZSTRING} for encoding characters in `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 7:38:11 GMT (Sunday 27th April 2025)"
	revision: "14"

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
		once ("PROCESS") -- thread safe proven in repository publisher
			Result := default_codec
		end

	Latin_1_codec: EL_ZCODEC
		once
			Result := Codec_factory.codec_by ({EL_ENCODING_TYPE}.Latin_1)
		end

	Unicode_table: SPECIAL [CHARACTER_32]
		once ("PROCESS") -- thread safe proven in repository publisher
			Result := Codec.unicode_table
		end

end
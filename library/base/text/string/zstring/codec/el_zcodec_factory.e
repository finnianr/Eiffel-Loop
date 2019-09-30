note
	description: "Factory for character codecs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-30 6:13:38 GMT (Monday   30th   September   2019)"
	revision: "8"

class
	EL_ZCODEC_FACTORY

inherit
	EL_FACTORY_CLIENT

	EL_SHARED_UTF_8_ZCODEC

	EL_MODULE_NAMING

feature {NONE} -- Factory

	new_codec (encoding: EL_ENCODING_BASE): EL_ZCODEC
		-- cached codec
		require
			has_codec: has_codec (encoding)
		do
			if encoding.is_utf_id (8) then
				Result := Utf_8_codec

			elseif has_codec_id (encoding.id) then
				Result := Codec_table.item (encoding.id)
			else
				create {EL_ISO_8859_1_ZCODEC} Result.make
			end
		end

	new_codec_by_id (id: INTEGER): EL_ZCODEC
		do
			inspect id
				when 1 .. 11, 13 .. 15 then
					Result := ISO_8859_factory.instance_from_alias (id.out, agent {EL_ZCODEC}.make)

				when 1250 .. 1258 then
					Result := Windows_factory.instance_from_alias (id.out, agent {EL_ZCODEC}.make)

			else
				create {EL_ISO_8859_1_ZCODEC} Result.make
			end
		end

	windows_codecs: TUPLE [
		EL_WINDOWS_1250_ZCODEC, EL_WINDOWS_1251_ZCODEC, EL_WINDOWS_1252_ZCODEC,
		EL_WINDOWS_1253_ZCODEC, EL_WINDOWS_1254_ZCODEC, EL_WINDOWS_1255_ZCODEC,
		EL_WINDOWS_1256_ZCODEC, EL_WINDOWS_1257_ZCODEC, EL_WINDOWS_1258_ZCODEC
	]
		do
			create Result
		end

	ISO_8859_codecs: TUPLE [
		EL_ISO_8859_1_ZCODEC, EL_ISO_8859_2_ZCODEC, EL_ISO_8859_3_ZCODEC,
		EL_ISO_8859_4_ZCODEC, EL_ISO_8859_5_ZCODEC, EL_ISO_8859_6_ZCODEC,
		EL_ISO_8859_7_ZCODEC, EL_ISO_8859_8_ZCODEC, EL_ISO_8859_9_ZCODEC,
		EL_ISO_8859_10_ZCODEC, EL_ISO_8859_11_ZCODEC,
--		EL_ISO_8859_12_ZCODEC is not available as No. 12 was missing from the original C-source code
--		used to generate codecs
		EL_ISO_8859_13_ZCODEC, EL_ISO_8859_14_ZCODEC, EL_ISO_8859_15_ZCODEC
	]
		do
			create Result
		end

feature {NONE} -- Status query

	has_codec (encoding: EL_ENCODING_BASE): BOOLEAN
		do
			Result := encoding.is_utf_id (8) or else has_codec_id (encoding.id)
		end

	has_codec_id (id: INTEGER): BOOLEAN
		do
			inspect id
				when 1 .. 11, 13 .. 15 then
					Result := True

				when 1250 .. 1258 then
					Result := True

			else end
		end

feature {NONE} -- Constants

	Codec_table: EL_CACHE_TABLE [EL_ZCODEC, INTEGER]
		once
			create Result.make_equal (30, agent new_codec_by_id)
		end

	ISO_8859_factory: EL_OBJECT_FACTORY [EL_ZCODEC]
		once
			create Result.make (agent Naming.class_as_lower_snake (?, 3, 1), ISO_8859_codecs)
		end

	Windows_factory: EL_OBJECT_FACTORY [EL_ZCODEC]
		once
			create Result.make (agent Naming.class_as_lower_snake (?, 2, 1), windows_codecs)
		end
end

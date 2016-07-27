note
	description: "Summary description for {EL_SHARED_CODEC_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:35:49 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	EL_SHARED_CODEC_FACTORY

inherit
	EL_FACTORY_CLIENT

feature {NONE} -- Factory

	new_iso_8859_codec (id: INTEGER): EL_ISO_8859_CODEC
		require
			valid_id: (1 |..| 15).has (id) and id /= 12
		do
			Result := ISO_8859_factory.instance_from_class_name (ISO_8859_template #$ [id], agent {EL_ISO_8859_CODEC}.make)
		end

	new_windows_codec (id: INTEGER): EL_WINDOWS_CODEC
		require
			valid_id: (1250 |..| 1258).has (id)
		do
			Result := Windows_factory.instance_from_class_name (Windows_template #$ [id], agent {EL_WINDOWS_CODEC}.make)
		end

feature {NONE} -- Constants

	Available_iso_8859_codecs: TUPLE [
		EL_ISO_8859_1_CODEC, EL_ISO_8859_2_CODEC, EL_ISO_8859_3_CODEC, EL_ISO_8859_4_CODEC, EL_ISO_8859_5_CODEC,
		EL_ISO_8859_6_CODEC, EL_ISO_8859_7_CODEC, EL_ISO_8859_8_CODEC, EL_ISO_8859_9_CODEC, EL_ISO_8859_10_CODEC,
		EL_ISO_8859_11_CODEC, EL_ISO_8859_13_CODEC, EL_ISO_8859_14_CODEC, EL_ISO_8859_15_CODEC
	]
			-- Codecs compiled into Eiffel system
			-- 1SO-8859-12 is missing?
		once
			create Result
		end

	Available_windows_codecs: TUPLE [
		EL_WINDOWS_1250_CODEC, EL_WINDOWS_1251_CODEC, EL_WINDOWS_1252_CODEC, EL_WINDOWS_1253_CODEC,
		EL_WINDOWS_1254_CODEC, EL_WINDOWS_1255_CODEC, EL_WINDOWS_1256_CODEC, EL_WINDOWS_1257_CODEC,
		EL_WINDOWS_1258_CODEC
	]
			-- Codecs compiled into Eiffel system
		once
			create Result
		end

	ISO_8859_factory: EL_OBJECT_FACTORY [EL_ISO_8859_CODEC]
		once
			create Result
		end

	Windows_factory: EL_OBJECT_FACTORY [EL_WINDOWS_CODEC]
		once
			create Result
		end

	ISO_8859_template: EL_ASTRING
		once
			Result := "EL_ISO_8859_$S_CODEC"
		end

	Windows_template: EL_ASTRING
		once
			Result := "EL_WINDOWS_$S_CODEC"
		end

end
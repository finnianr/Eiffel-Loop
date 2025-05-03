note
	description: "Ways to implement ${EL_ZCODEC}.as_zcode"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 9:28:31 GMT (Saturday 3rd May 2025)"
	revision: "24"

class
	ZCODEC_AS_Z_CODE

inherit
	STRING_BENCHMARK_COMPARISON
		redefine
			initialize
		end

	HEXAGRAM_NAMES_I

	EL_SHARED_ZSTRING_CODEC
		rename
			Codec as Shared_Codec
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			codec := Shared_codec
		end

feature -- Access

	Description: STRING = "ZCODEC.as_zcode variations"

feature -- Basic operations

	execute
		do
			compare ("Convert characters in Name_manifest", <<
				["{EL_ZCODEC}.as_zcode", agent do_method (Name_manifest, 1)],
				["Alternative method",	 agent do_method (Name_manifest, 2)]
			>>)
		end

feature {NONE} -- Operations

	frozen as_z_code (uc: CHARACTER_32): NATURAL
		local
			c: CHARACTER; code: NATURAL
		do
			code := uc.natural_32_code
			if code <= Max_ascii_unicode
				or else (code <= Max_8_bit_unicode and then unicode_table [code.to_integer_32] = uc)
			then
				Result := code

			else
				c := codec.latin_character (uc)
				if c = '%U' then
					if code < 0x100 then
						Result := Sign_bit | code
					else
						Result := code
					end
				else
					Result := c.natural_32_code
				end
			end
		ensure
			same_codec: Result = codec.as_z_code (uc)
		end

feature {NONE} -- Implementation

	do_method (string: STRING_32; id: INTEGER)
		local
			i, count: INTEGER; z_code: NATURAL
		do
			from count := 1 until count > 10_000 loop
				from i := 1 until i > string.count loop
					inspect id
						when 1 then
							z_code := Codec.as_z_code (string [i])
						when 2 then
							z_code := as_z_code (string [i])
					end
					i := i + 1
				end
				count := count + 1
			end
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC
end
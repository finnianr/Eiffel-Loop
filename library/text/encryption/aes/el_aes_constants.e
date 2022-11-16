note
	description: "Aes constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_AES_CONSTANTS

feature {NONE} -- Constants

	Block_size: INTEGER
		local
			key: AES_KEY
		once
			create key.make_spec_128
			Result := key.Block_size
		end

feature {NONE} -- Contract Support

	valid_key_bit_count (count: INTEGER): BOOLEAN
		do
			inspect count
				when 128, 192, 256 then
					Result := True
			else
			end
		end

	valid_key_byte_count (count: INTEGER): BOOLEAN
		do
			inspect count
				when 16, 24, 32 then
					Result := True
			else
			end
		end

end
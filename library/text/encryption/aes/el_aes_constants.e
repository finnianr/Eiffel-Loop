note
	description: "Aes constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-07 9:08:13 GMT (Friday 7th August 2020)"
	revision: "2"

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

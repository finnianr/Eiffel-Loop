note
	description: "Aes constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 21:07:30 GMT (Wednesday 20th February 2019)"
	revision: "1"

class
	EL_AES_CONSTANTS

feature {NONE} -- Constants

	Bit_sizes: ARRAYED_LIST [NATURAL]
		once
			create Result.make (3)
			across Byte_sizes as count loop
				Result.extend (count.item * 8)
			end
		end

	Block_size: INTEGER
		local
			key: AES_KEY
		once
			create key.make_spec_128
			Result := key.Block_size
		end

	Byte_sizes: ARRAY [NATURAL]
		once
			Result := << 16, 24, 32 >>
		end


end

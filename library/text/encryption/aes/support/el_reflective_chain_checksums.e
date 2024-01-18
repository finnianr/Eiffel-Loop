note
	description: "[
		Checksum/digest routines for chains conforming to ${ITERABLE [EL_REFLECTIVELY_SETTABLE]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 15:32:30 GMT (Wednesday 28th December 2022)"
	revision: "1"

deferred class
	EL_REFLECTIVE_CHAIN_CHECKSUMS [G -> EL_REFLECTIVELY_SETTABLE]

inherit
	ITERABLE [G]
		undefine
			is_equal, copy
		redefine
			new_cursor
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_DIGESTS

feature -- Digests

	crc_32_digest: NATURAL
		-- CRC-32 digest of all data in list
		local
			crc: like crc_generator
		do
			crc := crc_generator
			across Current as list loop
				if attached {EL_STORABLE} list.item as item implies not item.is_deleted then
					list.item.write_to (crc)
				end
			end
			Result := crc.checksum
		end

	md5_digest: SPECIAL [NATURAL_8]
		-- MD5 digest of all data in list
		do
			Result := md5.digest
		end

	md5_digest_base_64: STRING
		do
			Result := md5.digest_base_64
		end

	md5_digest_string: STRING
		do
			Result := md5.digest_string
		end

feature {NONE} -- Implementation

	new_cursor: INDEXABLE_ITERATION_CURSOR [G]
			-- <Precursor>
		deferred
		end

feature {NONE} -- Implementation

	md5: like Md5_128
		-- shared MD5 digest of all data in list
		do
			Result := Md5_128
			Result.reset
			across Current as list loop
				if attached {EL_STORABLE} list.item as item implies not item.is_deleted then
					list.item.write_to (Result)
				end
			end
		end

end
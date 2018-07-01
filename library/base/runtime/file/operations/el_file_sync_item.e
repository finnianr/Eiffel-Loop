note
	description: "Summary description for {EL_FILE_SYNC_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_FILE_SYNC_ITEM

inherit
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature {NONE} -- Initialization

	make
		local
			l_crc: like crc_generator
		do
			l_crc := crc_generator
			sink_content (l_crc)
			current_digest := l_crc.checksum
		end

feature -- Access

	current_digest: NATURAL

	previous_digest: NATURAL

	file_path: EL_FILE_PATH
		deferred
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := previous_digest /= current_digest
		end

feature {NONE} -- Implementation

	current_digest_ref: NATURAL_32_REF
		do
			Result := current_digest.to_reference
		end

	sink_content (crc: like crc_generator)
		deferred
		end
end

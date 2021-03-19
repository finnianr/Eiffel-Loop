note
	description: "File transfer synchronization item based on CRC 32 digests"
	descendants: "[
			EL_CRC_32_SYNC_ITEM*
				[$source EL_FILE_SYNC_ITEM]*
				[$source EL_HTML_FILE_SYNC_ITEM]*
					[$source EIFFEL_CLASS]
						[$source LIBRARY_CLASS]
					[$source REPOSITORY_HTML_PAGE]*
						[$source EIFFEL_CONFIGURATION_INDEX_PAGE]
						[$source REPOSITORY_SITEMAP_PAGE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-18 17:44:09 GMT (Thursday 18th March 2021)"
	revision: "6"

deferred class
	EL_CRC_32_SYNC_ITEM

inherit
	ANY

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
note
	description: "[
		HTML file-sync item that store CRC-32 digest in meta tag
			
			<meta name="digest" content="<crc digest>"/>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-04 11:59:38 GMT (Saturday 4th April 2020)"
	revision: "6"

deferred class
	EL_HTML_FILE_SYNC_ITEM

inherit
	EL_CRC_32_SYNC_ITEM
		rename
			previous_digest as meta_crc_digest,
			make as make_sync
		end

feature {NONE} -- Initialization

	make (html_path: EL_FILE_PATH)
		local
			reader: EL_HTML_META_VALUE_READER [EL_HTML_META_DIGEST]
		do
			create reader.make (html_path)
			meta_crc_digest := reader.meta_value.digest
			make_sync
		end

end

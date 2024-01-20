note
	description: "Shared cache table ${HASH_TABLE [EL_DOC_TYPE, NATURAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "14"

deferred class
	EL_SHARED_DOCUMENT_TYPES

inherit
	EL_SHAREABLE_CACHE_TABLE [EL_DOC_TYPE, NATURAL]

	EL_SHARED_DOC_TEXT_TYPE_ENUM

feature {NONE} -- Implementation

	new_shared_item (type_and_encoding: NATURAL): EL_DOC_TYPE
		do
			Result := type_and_encoding
		end

	document_type (doc_type, encoding: NATURAL): EL_DOC_TYPE
		require
			valid_type_and_encoding: Text_type.is_valid_value (doc_type.to_natural_8)
		do
			Result := shared_item ((doc_type |<< 16) | encoding)
		end

feature {NONE} -- Constants

	Once_cache_table: HASH_TABLE [EL_DOC_TYPE, NATURAL]
		once
			create Result.make (5)
		end

end
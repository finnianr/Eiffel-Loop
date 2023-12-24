note
	description: "Shared cache table [$source HASH_TABLE [EL_DOC_TYPE, NATURAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:44:35 GMT (Sunday 24th December 2023)"
	revision: "12"

deferred class
	EL_SHARED_DOCUMENT_TYPES

inherit
	EL_SHAREABLE_CACHE_TABLE [EL_DOC_TYPE, NATURAL]
		rename
			item as cached_document_type
		end

	EL_SHARED_DOC_TEXT_TYPE_ENUM

feature {NONE} -- Implementation

	new_item (type_and_encoding: NATURAL): EL_DOC_TYPE
		do
			Result := type_and_encoding
		end

	document_type (doc_type, encoding: NATURAL): EL_DOC_TYPE
		require
			valid_type_and_encoding: Text_type.is_valid_value (doc_type.to_natural_8)
		do
			Result := cached_document_type ((doc_type |<< 16) | encoding)
		end

feature {NONE} -- Constants

	Once_cache_table: HASH_TABLE [EL_DOC_TYPE, NATURAL]
		once
			create Result.make (5)
		end

end
note
	description: "Eif obj builder context class meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-08 10:28:17 GMT (Saturday 8th June 2019)"
	revision: "2"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			Reference_type_table
		end

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

create
	make

feature {NONE} -- Constants

	Reference_type_table: EL_HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER_32]
		once
			create Result.make (<<
				[Eif_obj_builder_context_type, {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT}],
				[Eif_obj_builder_context_collection_type, {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT}]
			>>)
			Result.merge (Precursor)
		end

end

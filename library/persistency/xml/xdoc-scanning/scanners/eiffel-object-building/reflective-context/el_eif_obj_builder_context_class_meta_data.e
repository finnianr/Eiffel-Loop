note
	description: "Eif obj builder context class meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-07 7:12:05 GMT (Friday 7th June 2019)"
	revision: "1"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			Base_reference_types, Reference_type_table
		end

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

create
	make

feature {NONE} -- Constants

	Base_reference_types: ARRAY [INTEGER]
		local
			list: ARRAYED_LIST [INTEGER]
		once
			create list.make_from_array (Builder_context_types)
			Precursor.do_all (agent list.extend)
			Result := list.to_array
		end

	Reference_type_table: EL_HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER_32]
		once
			create Result.make (<<
				[EIF_OBJ_BUILDER_CONTEXT, {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT}],
				[COLLECTION_EIF_OBJ_BUILDER_CONTEXT, {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT}]
			>>)
			Result.merge (Precursor)
		end

end

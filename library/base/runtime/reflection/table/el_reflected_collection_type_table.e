note
	description: "[
		Reflected [$source COLLECTION [G]] type table where G is a string convertable basic type
		using class [$source EL_STRING_CONVERSION_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 11:09:38 GMT (Monday 3rd May 2021)"
	revision: "7"

class
	EL_REFLECTED_COLLECTION_TYPE_TABLE

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_COLLECTION [ANY]]
		rename
			make as make_with_tuples
		redefine
			new_base_type_id
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			copy, default_create, is_equal
		end

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make
		local
			type_list: EL_TUPLE_TYPE_LIST [EL_COLLECTION_TYPE [ANY]]
		do
			create type_list.make_from_tuple (new_type_tuple)
			make_size (type_list.count)
			create latin_1_data_types.make (type_list.count - Class_id.Unicode_types.count)
			across type_list as type loop
				if attached {EL_COLLECTION_TYPE [ANY]} Factory.new_item_from_type (type.item) as collection then
					if not Class_id.Unicode_types.has (collection.item_type_id) then
						latin_1_data_types.extend (collection.type_id)
					end
					extend (collection.reflected_type, collection.type_id)
				end
			end
			initialize
		end

feature -- Status query

	is_character_data (item_type_id: INTEGER): BOOLEAN
		do
			Result := Class_id.Character_data_types.has (item_type_id)
		end

	is_latin_1_representable (collection_type_id: INTEGER): BOOLEAN
		do
			Result := across latin_1_data_types as type some
				type_conforms_to (collection_type_id, type.item)
			end
		end

feature {NONE} -- Implementation

	new_type_tuple: TUPLE [
		EL_COLLECTION_TYPE [INTEGER_8],
		EL_COLLECTION_TYPE [INTEGER_16],
		EL_COLLECTION_TYPE [INTEGER_32],
		EL_COLLECTION_TYPE [INTEGER_64],

		EL_COLLECTION_TYPE [NATURAL_8],
		EL_COLLECTION_TYPE [NATURAL_16],
		EL_COLLECTION_TYPE [NATURAL_32],
		EL_COLLECTION_TYPE [NATURAL_64],

		EL_COLLECTION_TYPE [REAL_32],
		EL_COLLECTION_TYPE [REAL_64],

		EL_COLLECTION_TYPE [BOOLEAN],
		EL_COLLECTION_TYPE [CHARACTER_8],
		EL_COLLECTION_TYPE [CHARACTER_32],

		EL_COLLECTION_TYPE [STRING_8],
		EL_COLLECTION_TYPE [STRING_32],
		EL_COLLECTION_TYPE [ZSTRING],

		EL_COLLECTION_TYPE [EL_DIR_PATH],
		EL_COLLECTION_TYPE [EL_FILE_PATH]
	]
		do
			create Result
		end

	new_base_type_id: INTEGER
		do
			Result := ({COLLECTION [ANY]}).type_id
		end

feature {NONE} -- Internal attributes

	latin_1_data_types: ARRAYED_LIST [INTEGER]
		-- collection types representable by latin-1 character set

feature {NONE} -- Constants

	Factory: EL_MAKEABLE_OBJECT_FACTORY
		once
			create Result
		end

end
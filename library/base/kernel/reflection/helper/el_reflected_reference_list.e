note
	description: "List of uninitialized ${EL_REFLECTED_REFERENCE} fields for type query purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-19 19:42:29 GMT (Monday 19th December 2022)"
	revision: "1"

class
	EL_REFLECTED_REFERENCE_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_REFERENCE [ANY]]
		rename
			make as make_list
		end

	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make (type_tuple: TUPLE)
		do
			make_list (type_tuple.count)
			append_types (type_tuple)
		end

feature -- Access

	non_abstract_type_table: HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER]
		do
			if attached non_abstract_types as type_list then
				create Result.make (type_list.count)
				across type_list as list loop
					Result.extend (list.item.generating_type, list.item.value_type.type_id)
				end
			else
				create Result.make (0)
			end
		end

	non_abstract_types: EL_ARRAYED_LIST [EL_REFLECTED_REFERENCE [ANY]]
		do
			Result := query_if (agent is_non_abstract)
		end

	string_type_id_list: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (10)
			across Current as list loop
				if attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} list.item then
					Result.extend (list.item.value_type.type_id)
				end
			end
		end

	storable_types: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (0)
			across Current as list loop
				if list.item.is_storable_type then
					Result.extend (list.item.value_type.type_id)
				end
			end
		end

feature -- Status query

	has_conforming (type_id: INTEGER): BOOLEAN
		do
			Result := across Current as list some
				{ISE_RUNTIME}.type_conforms_to (type_id, list.item.value_type.type_id)
			end
		end

feature -- Basic operations

	append_types (type_tuple: TUPLE)
		local
			type_list: EL_TUPLE_TYPE_ARRAY
		do
			create type_list.make_from_tuple (type_tuple)
			grow (count + type_list.count)
			across type_list as list loop
				if attached {EL_REFLECTED_REFERENCE [ANY]}
					Default_factory.new_item_from_type_id (list.item.type_id) as new
				then
					extend (new)
				end
			end
		end

feature {NONE} -- Implementation

	is_non_abstract (field: like item): BOOLEAN
		do
			Result := not field.is_abstract
		end

end
note
	description: "Evolicity tuple context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:00:46 GMT (Tuesday 18th March 2025)"
	revision: "12"

class
	EVC_TUPLE_CONTEXT

inherit
	EVC_CONTEXT_IMP
		rename
			make as make_context
		end

create
	make

feature {NONE} -- Initialization

	make (tuple: TUPLE; a_field_names: STRING)
		require
			enough_field_names: tuple.count = a_field_names.occurrences (',') + 1
		local
			index, hash_code: INTEGER; b: EL_BIT_ROUTINES
		do
			make_context
			field_names := a_field_names

--			digest for tuple types and field names
			hash_code := b.extended_hash (a_field_names.hash_code, {ISE_RUNTIME}.dynamic_type (tuple))

			Name_list_cache.set_new_item_target (Current)

			across Name_list_cache.item (hash_code) as list loop
				index := list.cursor_index
				if attached list.item as name then
					inspect tuple.item_code (index)
						when {TUPLE}.Boolean_code then
							put_boolean (name, tuple.boolean_item (index))

						when {TUPLE}.Real_64_code then
							put_double (name, tuple.real_64_item (index))

						when {TUPLE}.Integer_32_code then
							put_integer (name, tuple.integer_32_item (index))

						when {TUPLE}.Natural_32_code then
							put_natural (name, tuple.natural_32_item (index))

						when {TUPLE}.Real_32_code then
							put_real (name, tuple.real_32_item (index))

						when {TUPLE}.Reference_code then
							if attached tuple.reference_item (index) as ref then
								if attached {READABLE_STRING_GENERAL} ref as general then
									put_string (name, general)
								else
									put_any (name, ref)
								end
							end
					else
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_name_list (hash_code: INTEGER): EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_shared_adjusted (field_names, ',', {EL_SIDE}.Left)
		end

feature {NONE} -- Internal attributes

	field_names: STRING

feature {NONE} -- Constants

	Name_list_cache: EL_AGENT_CACHE_TABLE [EL_SPLIT_IMMUTABLE_STRING_8_LIST, INTEGER]
		once
			 create Result.make (11, agent new_name_list)
		end
end
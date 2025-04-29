note
	description: "[
		A table to look up reflected fields using ${EL_REFLECTED_FIELD}.export_name
		or the result of `translater.imported'. (Originating from implementation of ${EL_REFLECTIVE}.foreign_naming)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 11:25:45 GMT (Tuesday 29th April 2025)"
	revision: "2"

class
	EL_EXPORT_FIELD_TABLE

inherit
	EL_FIELD_TABLE
		rename
			make as make_table,
			has as has_readable_8,
			has_key as has_readable_8_key
		export
			{NONE} all
			{ANY} found_item, found
		end

create
	make

feature {NONE} -- Initialization

	make (a_field_table: like field_table; a_translater: like translater)
		do
			field_table := a_field_table; translater := a_translater
			if a_translater = Void then
				copy_from (a_field_table) -- no translations needed
			else
				make_table (3) -- keep it small as items are added only when needed
			end
		end

feature -- Status query

	has (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		do
			if has_general (foreign_name) then
				Result := True
			else
				Result := field_table.has_immutable (translated_key (foreign_name))
			end
		end

	has_key (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		-- If found, `found_item' is set to the field
		do
			if has_key_general (foreign_name) then
				Result := True

			elseif attached translated_key (foreign_name) as name and then field_table.has_immutable_key (name)
				and then attached field_table.found_item as field
			then
				if name ~ field.export_name then
					put (field, field.export_name)
				else
					put (field, name)
				end
				Result := True
			end
		end

feature {NONE} -- Implementation

	copy_from (other: EL_FIELD_TABLE)
		do
			capacity := other.capacity
			content := other.content
			control := other.control
			count := other.count
			deleted_item_position := other.deleted_item_position
			deleted_marks := other.deleted_marks
			found_item := other.found_item
			has_default := other.has_default
			hash_table_version_64 := other.hash_table_version_64
			ht_lowest_deleted_position := other.ht_lowest_deleted_position
			ht_deleted_key := other.ht_deleted_key
			ht_deleted_item := other.ht_deleted_item
			indexes_map := other.indexes_map
			iteration_position := other.iteration_position
			item_position := other.item_position
			iteration_position := other.iteration_position
			keys := other.keys
			object_comparison := other.object_comparison
		end

	translated_key (foreign_name: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		local
			l_result: STRING_8
		do
			if attached Name_buffer.to_same (foreign_name) as name_8 then
				if attached translater as l_translater then
					l_result := l_translater.imported (name_8)
				else
					create l_result.make_from_string (name_8)
				end
			end
			Result := Immutable_8.as_shared (l_result)
		end

feature {NONE} -- Internal attributes

	translater: detachable EL_NAME_TRANSLATER
		-- name translater originating from implementation of {EL_REFLECTIVE}.foreign_naming

	field_table: EL_FIELD_TABLE
		-- table with lowercase Eiffel names

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end
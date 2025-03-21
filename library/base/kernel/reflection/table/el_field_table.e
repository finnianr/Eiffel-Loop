note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 10:47:49 GMT (Friday 21st March 2025)"
	revision: "39"

class
	EL_FIELD_TABLE

inherit
	EL_IMMUTABLE_KEY_8_TABLE [EL_REFLECTED_FIELD]
		rename
			make as make_sized
		export
			{EL_REFLECTION_HANDLER} all
			{ANY} extend, found, found_item, count, start, after, forth,
					has_immutable_key, has_immutable, has, has_key,
					item_for_iteration, key_for_iteration, current_keys
		end

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_translater: like translater)
		do
			translater := a_translater
			make_equal (n)
			create imported_table.make (n)
		end

feature -- Status query

	has_imported (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		do
			Result := has_general (translated_key (foreign_name))
		end

	has_imported_key (foreign_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if translated `foreign_name' is present
		-- If found, `found_item' is set to the field
		do
			Result := has_key_general (translated_key (foreign_name))
		end

feature {NONE} -- Implementation

	new_imported (foreign_name: READABLE_STRING_GENERAL): STRING
		do
			if attached translater as t then
				Result := t.imported (Name_buffer.to_same (foreign_name))
			else
				Result := foreign_name.to_string_8
			end
		ensure
			not_buffer: not Name_buffer.is_same (Result)
		end

	translated_key (foreign_name: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached translater and then attached imported_table as table then
				if not table.has_key (foreign_name) then
					table.put (new_imported (foreign_name), foreign_name.twin) -- twinning essential
				end
				Result := table.found_item
			else
				Result := foreign_name
			end
		end

feature {NONE} -- Internal attributes

	imported_table: STRING_TABLE [STRING]

	translater: detachable EL_NAME_TRANSLATER

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end
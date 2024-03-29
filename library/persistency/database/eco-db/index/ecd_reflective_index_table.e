note
	description: "[
		A field index conforming to ${ECD_INDEX_TABLE [EL_STORABLE, HASHABLE]} that uses
		a ${EL_REFLECTED_FIELD} instance `field' to obtain the value of the indexed field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	ECD_REFLECTIVE_INDEX_TABLE [
		G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end, K -> detachable HASHABLE
	]

inherit
	ECD_INDEX_TABLE [G, K]
		rename
			make as make_index
		end

create
	make

feature {NONE} -- Initialization

	make (a_list: like list; a_field: like field)
		require
			matching_type: a_field.type ~ {K}
		do
			field := a_field
			make_index (a_list)
		end

feature {NONE} -- Implementation

	item_key (v: G): K
		-- allows possibility to call `a_item.key' directly in `ECD_KEY_INDEX' descendant
		do
			if attached {K} field.value (v) as value then
				Result := value
			end
		end

feature {NONE} -- Internal attributes

	field: EL_REFLECTED_FIELD

end
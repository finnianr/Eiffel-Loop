note
	description: "[
		A field index conforming to [$source ECD_INDEX_TABLE [EL_STORABLE, HASHABLE]] that uses
		a [$source EL_REFLECTED_FIELD] instance `field' to obtain the value of the indexed field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 13:50:58 GMT (Monday 24th May 2021)"
	revision: "1"

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

	make (a_list: like list; a_field: like field; n: INTEGER)
		require
			matching_type: a_field.type ~ {K}
		do
			field := a_field
			make_index (a_list, n)
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
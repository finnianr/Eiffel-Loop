note
	description: "Factory to create initialized instances of objects conforming to ${EL_REFLECTED_FIELD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:00:50 GMT (Monday 5th May 2025)"
	revision: "7"

class
	EL_INITIALIZED_FIELD_FACTORY

inherit
	EL_INITIALIZED_OBJECT_FACTORY [EL_REFLECTED_FIELD_FACTORY [EL_REFLECTED_FIELD], EL_REFLECTED_FIELD]
		export
			{NONE} all
		end

feature -- Factory

	new_item (
		type: TYPE [EL_REFLECTED_FIELD]; a_object: ANY; a_index: INTEGER; a_name: IMMUTABLE_STRING_8
	): EL_REFLECTED_FIELD
		do
			if attached new_item_factory (type.type_id) as l_factory then
				Result := l_factory.new_item (a_object, a_index, a_name)
			else
				create {EL_REFLECTED_REFERENCE_ANY} Result.make (a_object, a_index, a_name)
			end
		end
end
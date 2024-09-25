note
	description: "${EL_INITIALIZED_OBJECT_FACTORY} for types conforming to ${ARRAYED_LIST [ANY]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-24 16:45:27 GMT (Tuesday 24th September 2024)"
	revision: "2"

class
	EL_INITIALIZED_ARRAYED_LIST_FACTORY

inherit
	EL_INITIALIZED_OBJECT_FACTORY [EL_ARRAYED_LIST_FACTORY [ARRAYED_LIST [ANY]], ARRAYED_LIST [ANY]]

feature -- Factory

	new_list (a_item_type: TYPE [ANY]; size: INTEGER): detachable EL_ARRAYED_LIST [ANY]
		do
			if attached new_generic_type_factory ({EL_ARRAYED_LIST [ANY]}, << a_item_type >>) as l_factory
				and then attached {EL_ARRAYED_LIST [ANY]} l_factory.new_item (size) as list
			then
				Result := list
			end
		end

	new_result_list (fn: FUNCTION [ANY]; size: INTEGER): detachable EL_ARRAYED_LIST [ANY]
		do
			Result := new_list (fn.generating_type.generic_parameter_type (2), size)
		end

end
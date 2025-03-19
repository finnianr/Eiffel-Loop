note
	description: "${EL_INITIALIZED_OBJECT_FACTORY} for types conforming to ${ARRAYED_LIST [ANY]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-19 8:09:31 GMT (Wednesday 19th March 2025)"
	revision: "3"

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
			if attached fn.generating_type as type then
				inspect type.generic_parameter_count
					when 1 then
					-- is expanded type
						Result := new_list (fn.last_result.generating_type, size)
				else
				-- is reference type
					Result := new_list (type.generic_parameter_type (2), size)
				end
			end
		end

feature {NONE} -- Constants

	Type_none: INTEGER
		once
			Result := ({NONE}).type_id
		end

end
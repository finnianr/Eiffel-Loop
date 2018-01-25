note
	description: "Summary description for {EL_REFLECTION_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 13:11:02 GMT (Wednesday 24th January 2018)"
	revision: "3"

class
	EL_REFLECTION_MANAGER

inherit
	HASH_TABLE [ANY, INTEGER_32]
		rename
			make as make_table
		export
			{NONE} all
		end

	EL_REFLECTOR_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_EIFFEL
		undefine
			is_equal, copy
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_default
			make_equal (3)
		end

feature -- Element change

	register (objects: ARRAY [ANY])
			-- register new objects makeable from a string for use in classes inheriting `EL_REFLECTIVE'
			-- Use this routine if register causes an invariant violation
		do
			restrict_access
				across objects as obj loop
					put (obj.item, obj.item.generating_type.type_id)
				end
			end_restriction
		end

	register_types (types: ARRAY [TYPE [ANY]])
		require
			valid_types: valid_types (types)
		local
			new_instance: ANY
		do
			-- Cannot accept type conforming to DATE_TIME because of invariant violation
			-- Use register_objects instead
			restrict_access
				across types as type loop
					if not has_key (type.item.type_id) then
						new_instance := Eiffel.new_instance_of (type.item.type_id)
						if attached {EL_MAKEABLE_FROM_STRING} new_instance as string_makeable then
							string_makeable.make_default
							put (string_makeable, type.item.type_id)
						elseif attached {EL_MAKEABLE} new_instance as makeable then
							makeable.make
							put (makeable, type.item.type_id)
						end
					end
				end
			end_restriction
		end

feature -- Contract Support

	valid_types (types: ARRAY [TYPE [ANY]]): BOOLEAN
		-- True if all types conform to either `EL_MAKEABLE' or `EL_MAKEABLE_FROM_STRING'
		do
			restrict_access
				Result := across types as type all
					across << Makeable_from_string_type, Makeable_type >> as base_type some
						Eiffel.field_conforms_to (type.item.type_id, base_type.item)
					end
				end
			end_restriction
		end

feature -- Access

	default_value_by_type (type_id: INTEGER): ANY
		do
			restrict_access
				if attached item (type_id) as l_item then
					Result := l_item.twin
				end
			end_restriction
		end
end



note
	description: "[
		Shared access to factory objects conforming to ${EL_INITIALIZED_OBJECT_FACTORY}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-11 9:01:51 GMT (Wednesday 11th September 2024)"
	revision: "11"

deferred class
	EL_SHARED_FACTORIES

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	factory_for_type (type_id: INTEGER): detachable like Factory_list.item
		-- factory to create initialized object of type `type_id' or `Void' if none
		local
			found: BOOLEAN
		do
			across Factory_list as list until found loop
				if list.item.is_valid_type (type_id) then
					Result := list.item
					found := True
				end
			end
		end

feature {NONE} -- Factories

	Arrayed_list_factory: EL_INITIALIZED_ARRAYED_LIST_FACTORY
		once
			create Result
		end

	Date_factory: EL_INITIALIZED_OBJECT_FACTORY [EL_DATE_FACTORY [DATE], DATE]
		once
			create Result
		end

	Date_time_factory: EL_INITIALIZED_OBJECT_FACTORY [EL_DATE_TIME_FACTORY [DATE_TIME], DATE_TIME]
		once
			create Result
		end

	Default_factory: EL_INITIALIZED_OBJECT_FACTORY [EL_DEFAULT_CREATE_FACTORY [ANY], ANY]
		once
			create Result
		end

	Hash_table_factory: EL_INITIALIZED_HASH_TABLE_FACTORY
		once
			create Result
		end

	Makeable_factory: EL_INITIALIZED_OBJECT_FACTORY [EL_MAKEABLE_FACTORY [EL_MAKEABLE], EL_MAKEABLE]
		once
			create Result
		end

	Makeable_from_string_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_MAKEABLE_FROM_STRING_FACTORY [EL_MAKEABLE_FROM_STRING [STRING_GENERAL]],
		EL_MAKEABLE_FROM_STRING [STRING_GENERAL]
	]
		once
			create Result
		end

	String_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_STRING_FACTORY [READABLE_STRING_GENERAL], READABLE_STRING_GENERAL
	]
		once
			create Result
		end

	Time_factory: EL_INITIALIZED_OBJECT_FACTORY [EL_TIME_FACTORY [TIME], TIME]
		once
			create Result
		end

feature {NONE} -- Constants

	Factory_list: ARRAY [EL_INITIALIZED_OBJECT_FACTORY [EL_FACTORY [ANY], ANY]]
		once
			Result := <<
				Arrayed_list_factory, Date_factory, Date_time_factory, Time_factory,
				Makeable_factory, String_factory, Default_factory
			>>
		ensure
			default_is_last: Factory_list [Factory_list.count] = Default_factory
		end

end
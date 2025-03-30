note
	description: "Windows registry routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:55:57 GMT (Sunday 30th March 2025)"
	revision: "12"

class
	EL_WINDOWS_REGISTRY_ROUTINES

inherit
	EL_MEMORY_ROUTINES

	EL_STRING_GENERAL_ROUTINES_I

	WEL_REGISTRY_ACCESS_MODE
		export
			{NONE} all
		end

	WEL_REGISTRY_KEY_VALUE_TYPE
		export
			{NONE} all
		end

feature -- Access

	string (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := string_32 (key_path, key_name)
		end

	string_8 (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): STRING
		do
			Result := string_32 (key_path, key_name)
		end

	string_32 (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): STRING_32
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value then
				Result := value.string_value
			else
				create Result.make_empty
			end
		end

	string_list (key_path: DIR_PATH): EL_REGISTRY_STRING_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	integer (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): INTEGER
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value then
				Result := value.dword_value
			end
		end

	integer_list (key_path: DIR_PATH): EL_REGISTRY_INTEGER_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	data (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): MANAGED_POINTER
		do
			if attached {WEL_REGISTRY_KEY_VALUE} key_value (key_path, key_name) as value then
				Result := value.data
			else
				create Result.make (0)
			end
		end

	data_list (key_path: DIR_PATH): EL_REGISTRY_RAW_DATA_VALUES_ITERABLE
		do
			create Result.make (key_path)
		end

	key_names (key_path: DIR_PATH): EL_REGISTRY_KEYS_ITERABLE
		-- list of keys under key_path
		do
			create Result.make (key_path)
		end

	value_names (key_path: DIR_PATH): EL_REGISTRY_VALUE_NAMES_ITERABLE
			-- list of value names under key_path
		do
			create Result.make (key_path)
		end

feature -- Element change

	set_string (key_path: DIR_PATH; name, value: READABLE_STRING_GENERAL)
		local
			string_value: WEL_REGISTRY_KEY_VALUE
		do
			create string_value.make (Reg_sz, to_unicode_general (value))
			set_value (key_path, to_unicode_general (name), string_value)
		end

	set_integer (key_path: DIR_PATH; name: READABLE_STRING_GENERAL; value: INTEGER)
		local
			dword_value: WEL_REGISTRY_KEY_VALUE
		do
			create dword_value.make_with_dword_value (value)
			set_value (key_path, to_unicode_general (name), dword_value)
		end

	set_binary_data (key_path: DIR_PATH; name: READABLE_STRING_GENERAL; value: MANAGED_POINTER)
		local
			binary_value: WEL_REGISTRY_KEY_VALUE
		do
			create binary_value.make_with_data (Reg_binary, value)
			set_value (key_path, to_unicode_general (name), binary_value)
		end

	set_value (key_path: DIR_PATH; name: READABLE_STRING_GENERAL; value: WEL_REGISTRY_KEY_VALUE)
		do
			registry.save_key_value (key_path, to_unicode_general (name), value)
		end

feature -- Removal

	remove_key_value (key_path: DIR_PATH; value_name: READABLE_STRING_GENERAL)
		local
			node_ptr: POINTER
		do
			if attached registry as reg then
				node_ptr := reg.open_key_with_access (key_path, Key_set_value)
				if is_attached (node_ptr) then
					reg.delete_value (node_ptr, to_unicode_general (value_name))
					reg.close_key (node_ptr)
				end
			end
		end

	remove_key (parent_path: DIR_PATH; key_name: READABLE_STRING_GENERAL)
		local
			node_ptr: POINTER
		do
			if attached registry as reg then
				node_ptr := reg.open_key_with_access (parent_path, Key_set_value)
				if is_attached (node_ptr) then
					reg.delete_key (node_ptr, to_unicode_general (key_name))
					reg.close_key (node_ptr)
				end
			end
		end

feature -- Status query

	has_key (parent_path: DIR_PATH): BOOLEAN
		local
			node_ptr: POINTER
		do
			if attached registry as reg then
				node_ptr := reg.open_key_with_access (parent_path, Key_read)
				Result := is_attached (node_ptr)
				reg.close_key (node_ptr)
			end
		end

feature {NONE} -- Implementation

	key_value (key_path: DIR_PATH; key_name: READABLE_STRING_GENERAL): detachable WEL_REGISTRY_KEY_VALUE
		do
			Result := registry.open_key_value (key_path, to_unicode_general (key_name))
		end

	registry: WEL_REGISTRY
		-- Do not use 'once'. Weird shit starts happening when using a shared instance
		do
			create Result
		end

end
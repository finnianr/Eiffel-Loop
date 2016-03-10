note
	description: "Summary description for {EL_WEL_REGISTRY_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_WINDOWS_REGISTRY_ROUTINES

inherit
	EL_MEMORY

feature -- Access

	string (path: EL_DIR_PATH; key_name: EL_ASTRING): EL_ASTRING
		do
			if attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value (path.unicode, key_name.to_unicode) as value then
				Result := value.string_value
			else
				create Result.make_empty
			end
		end

	data (path: EL_DIR_PATH; key_name: EL_ASTRING): MANAGED_POINTER
		do
			if attached {WEL_REGISTRY_KEY_VALUE} registry.open_key_value (path.unicode, key_name.to_unicode) as value then
				Result := value.data
			else
				create Result.make (0)
			end
		end

	sub_keys (path: EL_DIR_PATH): EL_ITERABLE_REGISTRY_KEYS
		do
			create Result.make (path)
		end

feature -- Element change

	set_string (reg_path: EL_DIR_PATH; name, value: EL_ASTRING)
		local
			registry_value: WEL_REGISTRY_KEY_VALUE
		do
			create registry_value.make ({WEL_REGISTRY_KEY_VALUE_TYPE}.Reg_sz, value.to_unicode)
			set_value (reg_path, name, registry_value)
		end

	set_integer (reg_path: EL_DIR_PATH; name: EL_ASTRING; value: INTEGER)
		do
			set_value (reg_path, name, create {WEL_REGISTRY_KEY_VALUE}.make_with_dword_value (value))
		end

	set_binary_data (reg_path: EL_DIR_PATH; name: EL_ASTRING; value: MANAGED_POINTER)
		local
			registry_value: WEL_REGISTRY_KEY_VALUE
		do
			create registry_value.make_with_data ({WEL_REGISTRY_KEY_VALUE_TYPE}.Reg_binary, value)
			set_value (reg_path, name, registry_value)
		end

	set_value (reg_path: EL_DIR_PATH; name: EL_ASTRING; value: WEL_REGISTRY_KEY_VALUE)
		do
			registry.save_key_value (reg_path.unicode, name.to_unicode, value)
		end

feature -- Removal

	remove_key_value (reg_path: EL_DIR_PATH; value_name: EL_ASTRING)
		local
			node_ptr: POINTER;
			l_registry: like registry
		do
			l_registry := registry
			node_ptr := l_registry.open_key_with_access (reg_path.unicode, {WEL_REGISTRY_ACCESS_MODE}.Key_set_value)
			if is_attached (node_ptr) then
				l_registry.delete_value (node_ptr, value_name.to_unicode)
			end
		end

	remove_key (parent_path: EL_DIR_PATH; key_name: EL_ASTRING)
		local
			node_ptr: POINTER
			l_registry: like registry
		do
			l_registry := registry
			node_ptr := l_registry.open_key_with_access (parent_path.unicode, {WEL_REGISTRY_ACCESS_MODE}.Key_set_value)
			if is_attached (node_ptr) then
				l_registry.delete_key (node_ptr, key_name.to_unicode)
			end
		end

feature -- Status query

	has_key (parent_path: EL_DIR_PATH): BOOLEAN
		local
			node_ptr: POINTER
		do
			node_ptr := registry.open_key_with_access (parent_path.unicode, {WEL_REGISTRY_ACCESS_MODE}.Key_read)
			Result := is_attached (node_ptr)
		end

feature {NONE} -- Implementation

	registry: WEL_REGISTRY
			-- Do not use 'once'. Weird shit starts happening when using a shared instance
		do
			create Result
		end

end

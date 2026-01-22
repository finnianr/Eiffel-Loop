note
	description: "Type dependencies for a named class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-21 9:03:59 GMT (Friday 21st November 2025)"
	revision: "15"

class
	CLASS_DEPENDENCIES

inherit
	ANY

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH)
		local
			compiler: COMPACT_CLASS_NAME_SET_COMPILER
		do
			source_path := a_source_path
			if attached a_source_path.base_name.to_latin_1 as source_name then
				source_name.to_upper
				name := source_name
			end
			create compiler.make_from_file (a_source_path)
			dependency_set := compiler.class_name_set
			dependency_set.prune (name)
		end

feature -- Access

	big_dependency_count (a_class_table: like CLASS_TABLE; threshold_count: INTEGER): INTEGER
		-- count of dependency classes in `a_class_table' with `dependency_count' > `threshold_count'
		do
			across dependency_set as set loop
				if a_class_table.has_key (set.item)
					and then a_class_table.found_item.dependency_count (a_class_table) > threshold_count
				then
					Result := Result + 1
				end
			end
		end

	dependency_count (a_class_table: like CLASS_TABLE): INTEGER
		-- dependency count
		local
			is_counted_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		do
			create is_counted_set.make_equal (a_class_table.count // 2)
			Result := internal_dependency_count (a_class_table, is_counted_set)
		end

	dependency_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		-- set of classes on which class `name' depends

	name: IMMUTABLE_STRING_8

	source_path: FILE_PATH

feature {CLASS_DEPENDENCIES} -- Implementation

	internal_dependency_count (a_class_table: like CLASS_TABLE; is_counted_set: EL_HASH_SET [IMMUTABLE_STRING_8]): INTEGER
		-- recursive dependency count for `a_class'
		do
			is_counted_set.put (name)
			if is_counted_set.inserted then
				Result := 1
				across dependency_set as set loop
					if a_class_table.has_key (set.item) then
						Result := Result + a_class_table.found_item.internal_dependency_count (a_class_table, is_counted_set)
					end
				end
			end
		end

feature -- Type definitions

	CLASS_TABLE: EL_HASH_TABLE [CLASS_DEPENDENCIES, IMMUTABLE_STRING_8]
		require
			never_called: False
		once
			create Result.make (0)
		end

end
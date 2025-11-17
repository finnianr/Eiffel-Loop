note
	description: "Type dependencies for a named class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-17 16:04:51 GMT (Monday 17th November 2025)"
	revision: "13"

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

	circular_dependent: detachable CLASS_DEPENDENCIES

	dependency_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		-- set of classes on which class `name' depends

	name: IMMUTABLE_STRING_8

	source_path: FILE_PATH

feature -- Element change

	try_bind (candidate: CLASS_DEPENDENCIES)
		do
			if dependency_set.has (candidate.name) and then candidate.dependency_set.has (name) then
				circular_dependent := candidate
				dependency_set.merge (candidate.dependency_set)
				dependency_set.prune (name)
			end
		end

end
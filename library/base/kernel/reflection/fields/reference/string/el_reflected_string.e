note
	description: "Reflected field that conforms to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 19:12:11 GMT (Monday 9th September 2024)"
	revision: "31"

deferred class
	EL_REFLECTED_STRING [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_REFLECTED_HASHABLE_REFERENCE [S]
		rename
			set_from_string as set_from_string_general
		undefine
			reset, set_from_readable, set_from_memory, write, write_to_memory
		redefine
			append_to_string, group_type, post_make, new_factory, to_string, set_from_string_general
		end

	EL_STRING_HANDLER

feature {EL_CLASS_META_DATA} -- Initialization

	post_make
		-- initialization after types have been set
		do
			Precursor
			is_conforming := type_id /= strict_type_id
		end

feature -- Access

	group_type: TYPE [ANY]
		do
			Result := {READABLE_STRING_GENERAL}
		end

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

feature -- Status query

	is_conforming: BOOLEAN
		-- `True' is `S' parameter is not the same as generator name suffix: EL_REFLECTED_*

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (v)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		deferred
		end

	set_from_string_general (a_object: EL_REFLECTIVE; general: READABLE_STRING_GENERAL)
		local
			new: S
		do
			if attached {S} general as str then
				new := str
			elseif attached value (a_object) as str then
				new := replaced (str, general)
			else
				new := replaced (create {S}.make (general.count), general)
			end
			set (a_object, new)
		ensure then
			same_string: value (a_object).same_string (general)
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [S]
		do
			if attached {EL_FACTORY [S]} String_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

	replaced (str: S; content: READABLE_STRING_GENERAL): S
		deferred
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		deferred
		end

end
note
	description: "Java object array of types conforming to [$source JAVA_OBJECT_REFERENCE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	J_OBJECT_ARRAY [G -> JAVA_OBJECT_REFERENCE create make, make_from_pointer end]

inherit
	JAVA_OBJECT_REFERENCE
		rename
			make as make_type
		redefine
			Jclass, Jni_type_signature
		end

	DEFAULT_JPACKAGE
		undefine
			default_create
		end

	EL_MODULE_EIFFEL

create
	make, default_create

feature {NONE} -- Initialization

	make (n: INTEGER)
			--
		local
			l_item: like new_item
		do
			l_item := new_item
			make_from_pointer (jorb.new_object_array (n, l_item.jclass.java_class_id, l_item.java_object_id))
		end

feature -- Status report

	count: INTEGER
			-- Number of cells in this array
		do
			Result := jni.get_array_length (java_object_id)
		ensure
			positive_count: Result >= 0
		end

	valid_index (index: INTEGER): BOOLEAN
			--
		do
			Result := (index >= 1) and (index <= count)
		end

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): G assign put
			-- Entry at index `i', if in index interval
		do
			create Result.make_from_pointer (jorb.get_object_array_element (java_object_id, i - 1))
		end

feature -- Element change

	put (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		require
			valid_index: valid_index (i)
		do
			jorb.set_object_array_element (java_object_id, i - 1, v.java_object_id)
		end

feature {NONE} -- Implementation

	jclass: JAVA_CLASS_REFERENCE
			--
		do
			Result := new_item.jclass
		end

	jni_type_signature: STRING
			--
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.character_string ('[') + new_item.jni_type_signature
		end

	new_item: G
		do
			if attached {G} Eiffel.new_object ({G}) as l_item then
				Result := l_item
			end
		end

end
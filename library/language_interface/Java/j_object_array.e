note
	description: "Summary description for {JAVA_ARRAY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	J_OBJECT_ARRAY [G -> JAVA_OBJECT_REFERENCE create make, make_from_pointer end]

inherit
	JAVA_OBJECT_REFERENCE
		rename
			make as make_type
		redefine
			Jni_type_signature, default_create
		end

	DEFAULT_JPACKAGE
		undefine
			default_create
		end

create
	make, default_create

feature {JAVA_ROUTINE} -- Initialization

	default_create
			--
		do
			create default_item.make
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
			--
		do
			default_create
			make_from_pointer (
				jorb.new_object_array (n, default_item.jclass.java_class_id, default_item.java_object_id)
			)
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

	Jclass: JAVA_CLASS_REFERENCE
			--
		do
			Result := default_item.Jclass
		end

	default_item: G

feature -- Constant

	Jni_type_signature: STRING
			--
		do
			Result := Precursor
			Result.prepend_character ('[')
		end

end

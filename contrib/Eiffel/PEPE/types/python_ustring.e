note
	description: "Unicode objects as they are represented in Python"
	author: "Daniel Rodriguez"
	date: "$Date$"
	file: "$Workfile: $"
	revision: "$Revision$"

class
	PYTHON_USTRING

inherit
	PYTHON_SEQUENCE
		redefine
			py_type_ptr
		end

create
	borrowed,
	new

feature -- Access

	py_type_ptr: POINTER
			--
		do
			Result := c_py_unicode_type
		end

feature -- Status report

	
feature -- Measurement

	size: INTEGER
			-- Element count
		do
			Result := c_py_string_size (py_obj_ptr)
		end

end -- class PYTHON_STRING

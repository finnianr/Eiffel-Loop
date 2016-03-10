note
	description: "Class type in Python"
	author: "Daniel Rodriguez"
	file: "$Workfile: "
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_CLASS
inherit
	PYTHON_CALLABLE
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
			Result := c_py_class_type
		end
		
feature -- Status report

	is_a_class_object: BOOLEAN
			-- Is `Current' a Python class object?
		do
			Result := c_py_class_check (py_obj_ptr) = 1
		end
		
feature -- Basic routines

	call
			-- Call `Current' 
		do
			
		end
		
invariant
	right_type: is_a_class_object
end -- class PYTHON_CLASS

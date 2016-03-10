note
	description: "Modules in Python"
	author: "Daniel Rodriguez"
	file: "$Workfile: $"
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_MODULE

inherit
	PYTHON_OBJECT
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
			Result := c_py_module_type
		end
	
	dict: PYTHON_DICTIONARY
			-- Dictionary that implements the module's scope
		do
			Result ?= borrowed_python_object (c_py_module_get_dict (py_obj_ptr))
		end
		
	name: STRING
			-- Module's name as a Python object
		do
			create Result.make_from_c (c_py_module_get_name (py_obj_ptr))
		end
		
	documentation: STRING
			-- Module's __doc__ string.
		do
			Result := dict.item_at_string (doc_attribute_name).printable_out
		end
		
	filename: STRING
			-- Module's file name
		local
			p: POINTER
		do
			p := c_py_module_get_filename (py_obj_ptr)
			if  p /= default_pointer then
				create Result.make_from_c (p)
			else
				raise (py_system_error)
			end
		end

end -- class PYTHON_MODULE

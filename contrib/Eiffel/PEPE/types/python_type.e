note
	description: "Python type"
	author: "Daniel Rodríguez"
	file: "$Workfile: $"
	date: "$Date: $"
	revision: "$Revision: $"

class
	PYTHON_TYPE
	
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
		do
			Result := c_py_type_type
		end

feature -- Status report
	
	is_class_type: BOOLEAN
			-- Is Current a class type?
		do
			Result := py_obj_ptr = class_type.py_obj_ptr
		end
	
	is_dictionary_type: BOOLEAN
			-- Is Current a dictionary type?
		do
			Result := py_obj_ptr = dictionary_type.py_obj_ptr
		end
	
	is_string_type: BOOLEAN
			-- Is Current a string type?
		do
			Result := py_obj_ptr = string_type.py_obj_ptr
		end
	
	is_list_type: BOOLEAN
			-- Is Current a list type?
		do
			Result := py_obj_ptr = list_type.py_obj_ptr
		end
	
	is_tuple_type: BOOLEAN
			-- Is Current a tuple type?
		do
			Result := py_obj_ptr = tuple_type.py_obj_ptr
		end
	
	is_module_type: BOOLEAN
			-- Is Current a module type?
		do
			Result := py_obj_ptr = module_type.py_obj_ptr
		end
	
	is_integer_type: BOOLEAN
			-- Is Current an integer type?
		do
			Result := py_obj_ptr = integer_type.py_obj_ptr
		end
	
	is_boolean_type: BOOLEAN
			-- Is Current a boolean type?
		do
			Result := py_obj_ptr = boolean_type.py_obj_ptr
		end
	
	is_none_type: BOOLEAN
			-- Is Current a none type?
		do
			Result := py_obj_ptr = none_type.py_obj_ptr
		end
	
end -- class PYTHON_TYPE

note
	description: "Shared python interpreter. Each class using a python intrepreter must inherit from this one"
	author: "Daniel Rodríguez"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SHARED_PYTHON
	
feature -- Access

	python: PYTHON_INTERPRETER
			-- The Python interpretator
		once
			create Result.initialize			
		end
end

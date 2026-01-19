note
	description: "Circular class dependency example"

class A_DEPENDS_B

feature -- Access
	
	other: B_DEPENDS_A

	name: FILE_NAME

end


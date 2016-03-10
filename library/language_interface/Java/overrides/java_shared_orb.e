note
	description: "[
		Shared JNI environment.
	]"

class
	JAVA_SHARED_ORB

feature -- Access

	jni: JAVA_ORB
			-- Java object request broker
		once
			Result := jorb
		end

	jorb: JAVA_ORB
			-- Java object request broker
		once
			create Result
		end

end


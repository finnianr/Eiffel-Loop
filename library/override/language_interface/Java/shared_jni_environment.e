note
	description: "Shared JNI environment"

class
	SHARED_JNI_ENVIRONMENT

feature {NONE} -- Constants

	Jni: JNI_ENVIRONMENT
			-- Java object request broker
		once
			Result := jorb
		end

	Jorb: JNI_ENVIRONMENT
			-- Java object request broker
		once
			create Result
		end

end


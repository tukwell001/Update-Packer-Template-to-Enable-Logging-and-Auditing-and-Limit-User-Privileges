
n to enable logging and auditiing
enable_logging_auditing() {
# Install and Configure auditd
if [ -f /etc/debian_version ]; then
  sudo apt-get update
    sudo apt-get install auditd audispd-plugins
    elif [ -f /etc/redhat-release ]; then
    # Install auditd on RedHat-based systems
       sudo dnf install auditd
       else
         echo "Unsupported OS, Exiting..."            
	 exit 1
	 fi

	 # Ensure auditd starts on  boot and is running
	 sudo systemctl enable auditd && sudo service auditd start # Reason for the service is to record user ID


	 # Validate auditd is logging appropriate events
	  sudo auditctl -l 

	  # Capture the exit code
	  exit_code=$?
	  # Return the exit code
	  return $exit_code
	  }

	  # Function to limit user privileges

	  limit_user_privileges() {
	   
	    # Backup the original sudoers file
	     
	      cp /etc/sudoers /etc/sudoers.bak



	        # Configure sudoers file to limit root access
		 
		  echo "authorized_user ALL=(ALL) ALL" > /etc/sudoers.d/authorized_user
		   
		    chmod 440 /etc/sudoers.d/authorized_user

		     

		      # Ensure only authorized users have sudo access
		        
			usermod -aG sudo authorized_user

			  

			  # Validate sudo configuration
			    
			    visudo -c
			      
			      exit_code=$?

			        

				if [ $exit_code -ne 0 ]; then
				   
				    echo "Error in configuring sudoers. Exit code: $exit_code" 
				       # Restore the original sudoers file in case of error
				          
					     mv /etc/sudoers.bak /etc/sudoers
					       
					       else
					         
						   echo "User privileges limited successfully."  
						     rm /etc/sudoers.bak
						       
						       fi

						        

							 # Return the exit code
							  
							   return $exit_code


							   :}


							   # Main script execution
							   enable_logging_auditing
							   # check the exit code of the previous function
							   if [ $? -ne 0 ]; then
							   # Log the error and exit if the function failed
							   echo "Failed to enable logging and auditing. Exiting.."
							   exit 1
							   fi

							   Limit user privilege
							   #  Check the exit code of the previouus function
							   if [ $? -ne 0 ]; then
							   # Log the error and exit if the function failed
							   echo "Failed to limit user privileges. Exiting.."
							   exit 1
							   fi

							   echo "Script executed successfully."

							   exit 0

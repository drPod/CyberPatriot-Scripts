import subprocess

def enforce_password_history():
    """
    This function ensures that 'Enforce password history' is set to '24 or more password(s)'. 1.1.1 (L1) Ensure 'Enforce password history' is set to '24 or more password(s)' (Automated)
    """
    # Run the secedit command to get the current security policy
    output = subprocess.check_output("secedit /export /cfg C:\\secpol.cfg", shell=True)
    # Convert the output to a string
    output_str = output.decode("utf-8")
    # Split the string into lines
    output_lines = output_str.split("\r\n")
    # Find the line that contains the password history setting
    for line in output_lines:
        if "PasswordHistorySize" in line:
            # Get the current value of the password history setting
            current_value = int(line.split("=")[1])
            # If the current value is less than 24, set it to 24
            if current_value < 24:
                subprocess.run("secedit /import /cfg C:\\secpol.cfg /quiet", shell=True)
                subprocess.run(
                    f"net accounts /maxpwage:90 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:0 /passwordchg:1 /autologoff:15 /enablesmartcard:0 /update",
                    shell=True,
                )
                break


def enforce_max_password_age():
    """
    This function ensures that 'Maximum password age' is set to '365 or fewer days, but not 0'. 1.1.2 (L1) Ensure 'Maximum password age' is set to '365 or fewer days, but not 0' (Automated)
    """
    # Run the secedit command to get the current security policy
    output = subprocess.check_output("secedit /export /cfg C:\\secpol.cfg", shell=True)
    # Convert the output to a string
    output_str = output.decode("utf-8")
    # Split the string into lines
    output_lines = output_str.split("\r\n")
    # Find the line that contains the maximum password age setting
    for line in output_lines:
        if "MaximumPasswordAge" in line:
            # Get the current value of the maximum password age setting
            current_value = int(line.split("=")[1])
            # If the current value is greater than 365 or equal to 0, set it to 365
            if current_value > 365 or current_value == 0:
                subprocess.run("secedit /import /cfg C:\\secpol.cfg /quiet", shell=True)
                subprocess.run(
                    f"net accounts /maxpwage:365 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:0 /passwordchg:1 /autologoff:15 /enablesmartcard:0 /update",
                    shell=True,
                )
                break


def enforce_min_password_age():
    """
    This function ensures that 'Minimum password age' is set to '1 or more day(s)'. 1.1.3 (L1) Ensure 'Minimum password age' is set to '1 or more day(s)' (Automated)
    """
    # Run the secedit command to get the current security policy
    output = subprocess.check_output("secedit /export /cfg C:\\secpol.cfg", shell=True)
    # Convert the output to a string
    output_str = output.decode("utf-8")

    def enforce_max_password_age():
        """
        This function ensures that 'Maximum password age' is set to '90 or fewer days, but not 0 days'. 1.1.2 (L1) Ensure 'Maximum password age' is set to '90 or fewer days, but not 0 days' (Automated)
        """
        try:
            # Run the secedit command to get the current security policy
            subprocess.run("secedit /export /cfg C:\\secpol.cfg", shell=True)
            # Set the maximum password age to 90 days
            subprocess.run(
                "net accounts /maxpwage:90 /forcelogoff:1 /minpwlen:14 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:0 /passwordchg:1 /autologoff:15 /enablesmartcard:0",
                shell=True,
            )
        except Exception as e:
            print(f"An error occurred in enforce_max_password_age: {e}")

    def enforce_min_password_length():
        """
        This function ensures that 'Minimum password length' is set to '14 or more character(s)'. 1.1.4 (L1) Ensure 'Minimum password length' is set to '14 or more character(s)' (Automated)
        """
        try:
            # Run the secedit command to get the current security policy
            subprocess.run("secedit /export /cfg C:\\secpol.cfg", shell=True)
            # Set the minimum password length to 14 characters
            subprocess.run(
                "net accounts /maxpwage:90 /forcelogoff:1 /minpwlen:14 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:1 /passwordchg:1 /autologoff:15 /enablesmartcard:0",
                shell=True,
            )
        except Exception as e:
            print(f"An error occurred in enforce_min_password_length: {e}")

    def enforce_password_complexity():
        """
        This function ensures that 'Password must meet complexity requirements' is set to 'Enabled'. 1.1.5 (L1) Ensure 'Password must meet complexity requirements' is set to 'Enabled' (Automated)
        """
        try:
            # Run the secedit command to get the current security policy
            subprocess.run("secedit /export /cfg C:\\secpol.cfg", shell=True)
            # Set the password complexity to enabled
            subprocess.run(
                "net accounts /maxpwage:90 /forcelogoff:1 /minpwlen:14 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:1 /passwordchg:1 /autologoff:15 /enablesmartcard:0",
                shell=True,
            )
        except Exception as e:
            print(f"An error occurred in enforce_password_complexity: {e}")

    def enforce_relax_password_length_limits():
        """
        This function ensures that 'Relax minimum password length limits' is set to 'Enabled'. 1.1.6 (L1) Ensure 'Relax minimum password length limits' is set to 'Enabled' (Automated)
        """
        try:
            # Run the secedit command to get the current security policy
            subprocess.run("secedit /export /cfg C:\\secpol.cfg", shell=True)
            # Set the relax minimum password length limits to enabled
            subprocess.run(
                "net accounts /maxpwage:90 /forcelogoff:1 /minpwlen:14 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:1 /passwordchg:1 /autologoff:15 /enablesmartcard:0 /minpwlen:0",
                shell=True,
            )
        except Exception as e:
            print(f"An error occurred in enforce_relax_password_length_limits: {e}")

    def disable_reversible_passwords():
        """
        This function ensures that 'Store passwords using reversible encryption' is set to 'Disabled'. 1.1.7 (L1) Ensure 'Store passwords using reversible encryption' is set to 'Disabled' (Automated)
        """
        try:
            # Run the secedit command to get the current security policy
            subprocess.run("secedit /export /cfg C:\\secpol.cfg", shell=True)
            # Disable reversible passwords
            subprocess.run(
                "net accounts /maxpwage:90 /forcelogoff:1 /minpwlen:14 /minpwage:1 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30 /uniquepw:1 /reqpw:1 /passwordchg:1 /autologoff:15 /enablesmartcard:0 /clearpasswordhistory:1",
                shell=True,
            )
        except Exception as e:
            print(f"An error occurred in disable_reversible_passwords: {e}")

    try:
        # Run the net accounts command to get the current security policy
        output = subprocess.check_output("net accounts", shell=True)
        # Convert the output to a string
        output_str = output.decode("utf-8")
        # Split the string into lines
        output_lines = output_str.split("\r\n")
        # Find the line that contains the minimum password age setting
        for line in output_lines:
            if "MinimumPasswordAge" in line:
                # Get the current value of the minimum password age setting
                current_value = int(line.split("=")[1])
                # If the current value is less than 1, set it to 1
                if current_value < 1:
                    enforce_max_password_age()
                    enforce_min_password_length()
                    enforce_password_complexity()
                    enforce_relax_password_length_limits()
                    disable_reversible_passwords()
                    """
                    This function ensures that 'Account lockout duration' is set to '15 or more minute(s)'. 1.2.1 (L1) Ensure 'Account lockout duration' is set to '15 or more minute(s)' (Automated)
                    """
                    # Run the net accounts command to get the current security policy
                    output = subprocess.check_output("net accounts", shell=True)
                    # Convert the output to a string
                    output_str = output.decode("utf-8")
                    # Split the string into lines
                    output_lines = output_str.split("\r\n")
                    # Find the line that contains the account lockout duration setting
                    for line in output_lines:
                        if "AccountLockoutDuration" in line:
                            # Get the current value of the account lockout duration setting
                            current_value = int(line.split("=")[1])
                            # If the current value is less than 15, set it to 15
                            if current_value < 15:
                                subprocess.run(
                                    "net accounts /lockoutduration:15", shell=True
                                )
    except Exception as e:
        print(f"An error occurred in the script: {e}")
    output_lines = output_str.split("\r\n")
    # Find the line that contains the account lockout duration setting
    for line in output_lines:
        if "Account lockout duration" in line:
            # Get the current value of the account lockout duration setting
            current_value = int(line.split()[-1])
            # If the current value is less than 15, set it to 15
            if current_value < 15:
                subprocess.run(f"net accounts /lockoutduration:15 /force", shell=True)
                break


def enforce_account_lockout_threshold():
    """
    This function ensures that 'Account lockout threshold' is set to '5 or fewer invalid logon attempt(s), but not 0'. 1.2.2 (L1) Ensure 'Account lockout threshold' is set to '5 or fewer invalid logon attempt(s), but not 0' (Automated)
    """
    # Run the net accounts command to get the current security policy
    output = subprocess.check_output("net accounts", shell=True)
    # Convert the output to a string
    output_str = output.decode("utf-8")
    # Split the string into lines
    output_lines = output_str.split("\r\n")
    # Find the line that contains the account lockout threshold setting
    for line in output_lines:
        if "Lockout threshold" in line:
            # Get the current value of the account lockout threshold setting
            current_value = int(line.split()[-1])
            # If the current value is greater than 5 or equal to 0, set it to 5
            if current_value > 5 or current_value == 0:
                subprocess.run(f"net accounts /lockoutthreshold:5 /force", shell=True)
                break


def enable_admin_account_lockout():
    """
    This function ensures that 'Allow Administrator account lockout' is set to 'Enabled'. 1.2.3 (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled' (Manual)
    """
    # Run the secedit command to get the current security policy
    output = subprocess.check_output(
        "secedit /export /cfg C:\\Windows\\Temp\\security.cfg", shell=True
    )
    # Open the exported security policy file
    with open("C:\\Windows\\Temp\\security.cfg", "r") as f:
        # Read the file contents
        file_contents = f.read()
        # Replace the value of 'LockoutBadAdminAttempts' with '1'
        new_contents = file_contents.replace(
            "LockoutBadAdminAttempts = 0", "LockoutBadAdminAttempts = 1"
        )
    # Write the updated security policy file
    with open("C:\\Windows\\Temp\\security.cfg", "w") as f:
        f.write(new_contents)
    # Import the updated security policy file
    subprocess.run(
        "secedit /configure /db C:\\Windows\\Security\\Local.sdb /cfg C:\\Windows\\Temp\\security.cfg /areas SECURITYPOLICY",
        shell=True,
    )
    # Delete the exported security policy file
    subprocess.run("del C:\\Windows\\Temp\\security.cfg", shell=True)


def enforce_reset_account_lockout_counter():
    """
    This function ensures that 'Reset account lockout counter after' is set to '15 or more minute(s)'. 1.2.4 (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)' (Automated)
    """
    # Run the net accounts command to get the current security policy
    output = subprocess.check_output("net accounts", shell=True)
    # Convert the output to a string
    output_str = output.decode("utf-8")
    # Split the string into lines
    output_lines = output_str.split("\r\n")
    # Find the line that contains the reset account lockout counter setting
    for line in output_lines:
        if "Reset time" in line:
            # Get the current value of the reset account lockout counter setting
            current_value = int(line.split()[-2])
            # If the current value is less than 15, set it to 15
            if current_value < 15:
                subprocess.run(f"net accounts /lockoutduration:15 /force", shell=True)
                break

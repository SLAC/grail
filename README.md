# Mac Developer Machine Provisioning and Deployment

This set of scripts utilizes BASH, Ansible and Homebrew to provide a standardized environment for Python, PHP, Ruby and Javascript.

  - Base packages for Python, Ruby, PHP, BASH Enhancements
  - Does not provide all Ruby, Python, Ruby Packages 
  - No .NET for now, look for a branch soon

To utilize the package open a terminal app:

Click Finder -> in the Location bar at the top of your screen, click go -> click Applications -> Utilities -> Terminal

You can also use Command+space -> type terminal -> type Enter

Copy the line below (command+c) and paste it (command+v) into the terminal window and type enter

```curl https://raw.githubusercontent.com/SLAC-Lab/mac-dev-deployment/master/bootstrap.sh | bash```

Caveats;  There seems to be some timeouts with Homebrew and random packages.  I can't really control those.
Should you experience timeouts, or failures due to timeouts please re-run the above command.

You will know you are finished with you see the words:

``` All Done! Happy Coding! ```

You may see warnings and errors, they are generally safe to ignore.
As with all software, please examine the source before running a command a guy in a lab tells you to.

-V


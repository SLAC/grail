# Mac Developer Machine Provisioning and Deployment

This set of scripts utilizes BASH, Ansible and Homebrew to provide a standardized environment for Python, PHP, Ruby and Javascript.

  - Base packages for Python, Ruby, PHP, BASH Enhancements
  - Does not provide all Ruby, Python, Ruby Packages 
  - No .NET for now, look for a branch soon

To utilize the package open a terminal app:

Click Finder -> in the Location bar at the top of your screen, click go -> click Applications -> Utilities -> Terminal

You can also use Command+space -> type terminal -> type Enter

Copy the line below (command+c) and paste it (command+v) into the terminal window and type enter

```curl -s https://raw.githubusercontent.com/SLAC-OCIO/mac-dev-deployment/master/bootstrap.sh | bash -s https://github.com/SLAC-OCIO/superlumic-config admin```

Caveats;  There seems to be some timeouts with Homebrew and random packages.  I can't really control those.
Should you experience timeouts, or failures due to timeouts please re-run the above command.

You will know you are finished with you see the following:

``` localhost: xxx xxxxx xxxx xxxx failed=0```

Pay close attention to the `failed=0` as that means everything completed.
If you encounter errors run the command again, if you repeatedly encounter them, file a ticket in Service Now.

You may see warnings and errors, they are generally safe to ignore.
As with all software, please examine the source before running a command a guy in a lab tells you to.

For advanced documentation see the [Wiki](https://github.com/SLAC-OCIO/mac-dev-deployment/wiki)

### about
This is a package developed to assist Developers that are new to Drupal, get the toolchain in place to develop locally using a Macintosh Computer running OS-X 10.10 or higher.

Largely, it was designed to be self-contained, pulling from other projects only when necessary. However, SLAC Drupal Developers will need credentials in place (ssh keys) to utilize the scripts that download the private Drupal repositories.

If you're not a SLAC Drupal developer, the extra scripts that are not ran by bootstrap.sh, won't interest you - other than academically to see how I accomplished it.

The documentation in the PDF was pulled from Github and Drupal's support sections.  I take no credit for it's writing, but merely arranging it in a downloadable document.

We acknowledge that there are enterprise alternatives - however, a lack of resources dictates that we get this working, so others can begin developing. 



-V


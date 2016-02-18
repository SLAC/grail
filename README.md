# Grail
Grail makes it easier to get started with a new Mac, or spruce up your current one.  It uses Ansible, Superlumic, Python and Git to pull together the apps, programs and libraries necessary to do application developement and System Administration on OS-X.

  - Base packages for Python, Ruby, PHP, BASH enhancements, OS-X enhancments
  - Node and Javascript packages, with multiple versions of node and nvm
  - The Drupal version includes compass and susyone
   
  
## Requirements
 - OS-X 10.10 (Yosemite)  or
 - OS-X 10-11 (El Capitan)
 - Internet Connection
 - The ability to manage system level packages on your mac (sudo)

## Profiles
There are three profiles that can be utilized
  - All - A standard set of applications for a new Mac
  - Developer - An enhanced set of applications for common development uses
  - Drupal - An all encompassing platform, designed to get the Drupal development Neophyte to the point of writing code and site-building

## Runtime
On a 2011 MacMini (Intel i5 dual-core) with 8GB of memory and a solid state drive, sitting on the fastest internet there is, this took 45 minutes to complete.  Your millage may vary. 

## Usage
To utilize the package open a terminal app:

Click Finder -> in the Location bar at the top of your screen, click go -> click Applications -> Utilities -> Terminal

You can also use Command+space -> type terminal -> type Enter

Copy the line below (command+c) and paste it (command+v) into the terminal window and type enter
### Profile Choice
-----
If you want the basic set of applications paste the following line into your terminal:
```curl -s https://raw.githubusercontent.com/SLAC-OCIO/mac-dev-deployment/master/bootstrap.sh | bash -s all```

If you want a developer ready machine, for node, python, java paste the following line into your terminal:
```curl -s https://raw.githubusercontent.com/SLAC-OCIO/mac-dev-deployment/master/bootstrap.sh | bash -s admin```

If you want to start developing Drupal, using SLAC's codebases paste the following line into your terminal:
```curl -s https://raw.githubusercontent.com/SLAC-OCIO/mac-dev-deployment/master/bootstrap.sh | bash -s drupal```

Caveats: There may be some timeouts with Homebrew and random packages.Should you experience timeouts, or failures due to timeouts please re-run the above command.

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

### Origin

The initial need for Grail was born out of team consolidation.  The boss wanted us to crosstrain.  Getting started with Drupal development is a challenge as the toolchain required has a learning curve.  This pacakge speeds up the cross team integration. 

It is composed of several tricks from several bags. Many of the roles come from [Superlumic](https://github.com/superlumic) That package was developed with a lot of extensability in mind. I initially started with [Battleschool](https://github.com/spencergibb/battleschool), but found it was restricting me for my usecase. Either of them are great pacakges - I've tried to draw from both of them. I changed a few things that let us use this in Casper. I added some scripts that let the intrepid user grab all of the codebases. 

-xalg


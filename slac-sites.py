#!/usr/bin/env python
# encoding: utf-8

import os
import yaml
from git import Repo
from github import GithubException
#------------CFG---------------#
mypath = os.getcwd()
repolist = []
join = os.path.join

#Grab config info
with open(mypath + "/mycfg.yml", 'r') as ymlfile:
        cfg = yaml.load(ymlfile)
        local_www_path = cfg['misc']['LOCAL_PATH']
#make a list of repos
for section in cfg:
    if section == 'repos':
        repolist = cfg['repos']

#add those repos locally
def git_loop(local_www_path ,repolist):
    if repolist:
        try:
            for i,s in enumerate(repolist):
                print "-------------------------------------------"
                print "------ Building New Git Repository --------"
                print "-------------------------------------------"
                curdir = str(s)
                curpath = local_www_path + str(s)
                new_repo = Repo.init(curpath)
                init_local(curpath, curdir, new_repo)
                pull_slac_drupal_repos(curpath,  new_repo)
        except GithubException as ghe:
            print(ghe)

#create local repo
def init_local(curpath, curdir, new_repo):
    print "-------------------------------------------"
    print "-- Initializing local repo---"
    print "-------------------------------------------"
    assert new_repo
    remote_url=cfg['paths']['BASE_URL'] + curdir + '.git'
    if not new_repo.remotes:
        try:
            origin = new_repo.create_remote('origin',remote_url)
            assert origin.exists()
        except GithubException as ghe:
            print(ghe)
    return new_repo


#pull the remotes
def pull_slac_drupal_repos(url_user, new_repo):
    origin = new_repo.remote('origin')
    origin.fetch()
    origin.pull(origin.refs[0].remote_head)
    # new_repo.remotes.origin.pull()

#do that thing
def execute():
    git_loop(local_www_path, repolist,)

def main():
    pass


if __name__ == '__main__':
    main()
    execute()

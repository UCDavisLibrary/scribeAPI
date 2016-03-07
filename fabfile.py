import os

from fabric.api import local, settings, abort, run, cd, env, put, sudo
from fabric.contrib.console import confirm

import time
DEPLOY_WAIT_TIME = 15

timestamp="release-%s" % int(time.time() * 1000)

env.user = 'deploy'  # Special group with limited sudo
env.hosts = ['104.236.224.252']

code_dir = '/home/liza/scribeAPI'


def deploy():
    deploy_app()

def deploy_app():

    with cd(code_dir):
        run('git pull origin master')
        run('rake project:load["label_this","workflows","content"]')
    sudo('service unicorn_labelthis stop', shell=False)
    time.sleep(DEPLOY_WAIT_TIME)  # Wait for the process to die
    sudo('service unicorn_labelthis start', shell=False)
    print "Done deploying"

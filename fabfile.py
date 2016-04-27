import os

from fabric.api import local, settings, abort, run, cd, env, put, sudo
from fabric.contrib.console import confirm
import requests

import time
DEPLOY_WAIT_TIME = 15

timestamp="release-%s" % int(time.time() * 1000)

env.user = 'deploy'  # Special group with limited sudo
#env.hosts = ['104.236.224.252']
env.hosts = ['labelthis.lib.ucdavis.edu']

#code_dir = '/home/liza/scribeAPI'
code_dir = '/home/deploy/scribeAPI'

PROD_URL = "https://" + env.hosts[0]

def deploy():
    deploy_app()

def deploy_app():

    with cd(code_dir):
        run('git pull origin master')
        run('rake project:load["label_this","workflows","content"]')

    stop_host()
    time.sleep(DEPLOY_WAIT_TIME)  # Wait for the process to die
    start_host()
    ping_host()
    
    print("Done deploying")

def stop_host():
    sudo('service unicorn_labelthis stop', shell=False)

def start_host():
    sudo('service unicorn_labelthis start', shell=False)


def ping_host():
    """Ping the home page to start the refresh cycle for the static resources"""
    print("Requesting the home page to refresh static resources")
    requests.get(PROD_URL)

import os

from fabric.api import local, settings, abort, run, cd, env, put, sudo, hosts
from fabric.contrib.console import confirm
import requests

import time
DEPLOY_WAIT_TIME = 15

timestamp="release-%s" % int(time.time() * 1000)

env.user = 'deploy'  # Special group with limited sudo
#env.hosts = ['104.236.224.252']
QA_SERVER = 'labelthis-qa.lib.ucdavis.edu'
PROD_SERVER = 'XXXXlabelthis.lib.ucdavis.eduXXXX'

code_dir = '/home/deploy/scribeAPI'

PROD_URL = "https://" + PROD_SERVER + "/mark"
QA_URL = "https://" + QA_SERVER + "/mark"

# CURRENT_BRANCH = 'master'
CURRENT_BRANCH = 'deploy-fix'

def deploy():
    precompile_assets()
    deploy_app()


def precompile_assets():
    local("RAILS_ENV=production rake assets:precompile")
    # Commit the new assets
    local("git commit -m 'Automated deployment commit for " + timestamp + " to host " + env.hosts[0] + "' public/assets")
    local("git push origin " + CURRENT_BRANCH)

def deploy_app():

    with cd(code_dir):
        run('git pull origin ' + CURRENT_BRANCH)
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
    requests.get(QA_URL)
    requests.get(PROD_URL)

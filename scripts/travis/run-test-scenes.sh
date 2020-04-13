#!/bin/bash

#
# This source file is part of appleseed.
# Visit https://appleseedhq.net/ for additional information and resources.
#
# This software is released under the MIT license.
#
# Copyright (c) 2020 Kevin Masson, The appleseedhq Organization
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#


set -e
set -x # remove this
set -v # remove this

THISDIR=`pwd`


#--------------------------------------------------------------------------------------------------
# Create a report.
#--------------------------------------------------------------------------------------------------

echo "travis_fold:start:report"
echo "Creating a report..."

touch report.txt

echo "web url=$TRAVIS_BUILD_WEB_URL" >> report.txt
echo "job url=$TRAVIS_JOB_WEB_URL" >> report.txt
echo "commit=$TRAVIS_COMMIT" >> report.txt
echo "commit message=$TRAVIS_COMMIT_MESSAGE" >> report.txt
echo "job id=$TRAVIS_JOB_ID" >> report.txt
echo "job name=$TRAVIS_JOB_NAME" >> report.txt
echo "job number=$TRAVIS_JOB_NUMBER" >> report.txt

echo "travis_fold:end:report"

#--------------------------------------------------------------------------------------------------
# Deploy build.
#--------------------------------------------------------------------------------------------------

echo "travis_fold:start:deploy"
echo "Deploy travis build on our server..."

# Add server public key to known hosts.
echo $DEPLOY_SSH_KEY >> $HOME/.ssh/known_hosts

# Send build to server.
export SSHPASS=$DEPLOY_PASSWORD
sshpass -e rsync \
    -raz \
    --delete \
    --exclude=src \
    --exclude=docs \
    --exclude=cmake \
    ./* \
    $DEPLOY_USER@$DEPLOY_URL:$DEPLOY_FOLDER

echo "travis_fold:end:deploy"

set +x # remove this
set +v # remove this
set +e

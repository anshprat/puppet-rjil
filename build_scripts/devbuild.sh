set -xe

BUILD_TAG=anshu-tenant-build-gate-1 #Change this as required
ghprbPullId=669  # PR ID , will parametrize later
export KEY_NAME=combo # Key name , will parametrize
export env_file="/path/to/your/openrc" #will parametrize

export dns_server=IP.OF.YOUR.HTTPROXY
export env_http_proxy=http://${dns_server}:3128/
export env_https_proxy=http://${dns_server}:3128/

export module_git_cache=http://jiocloud.rustedhalo.com:8080/job/puppet-jiocloud-cache/lastSuccessfulBuild/artifact/cache.tar.gz
export git_protocol=https

export BUILD_NUMBER=$BUILD_TAG
# use the acceptance test environment (I may have to patch this a little)
export module_git_cache=http://jiocloud.rustedhalo.com:8080/job/puppet-jiocloud-cache/lastSuccessfulBuild/artifact/cache.tar.gz
export env=at
export cloud_provider=jio
##
# We should use combo keys, in which case bodepd/sorenh/hkumar/jenkins will have ssh access as ubuntu user,
# so commenting KEYNAME variable, for now which makes it to use combo (Dated: 2015-03-19) - Harish
##

# ensure that the correct pull request number and repo are set
export puppet_modules_source_repo=https://github.com/jiocloud/puppet-rjil
export pull_request_id=$ghprbPullId
./build_scripts/deploy.sh
./build_scripts/test.sh

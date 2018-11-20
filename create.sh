bosh create-release --force --tarball webide-broker-release.tgz --name webide-broker-release --version 2.0

bosh upload-release webide-broker-release.tgz

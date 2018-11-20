bosh delete-deployment -d webide-broker-service
bosh delete-release webide-broker-release

rm -r dev_releases
rm -r webide-broker-release.tgz

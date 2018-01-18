BRANCH="master"

if [ "$TRAVIS_PULL_REQUEST" = false ]; then
	if [ "$TRAVIS_TAG" ]; then
		cd $TRAVIS_BUILD_DIR/app/build/outputs/apk/release/

		echo "Publishing APK to tag: $TRAVIS_TAG"
		for apk in $(find *.apk -type f); do
		  apkName="${apk::-4}"
		  printf "Found APK: $apkName\n"
		  curl "https://uploads.github.com/repos/${TRAVIS_REPO_SLUG}/releases/${TRAVIS_TAG}/assets?access_token=${GITHUB_API_KEY}&name=${apkName}.apk" --header 'Content-Type: application/zip' --upload-file $apkName.apk -X POST
		done

		echo -e "Done publishing APK\n"
	else
		echo "Skipping APK publish because this commit does not have a tag"
	fi
else
	echo "Skipping APK publish because this is just a pull request"
fi
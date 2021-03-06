(Get-ChildItem ./Build/Release/log4uni.dll | Select-Object -ExpandProperty VersionInfo | Select-Object FileVersion | Select-Object -ExpandProperty FileVersion) -match "^\d+\.\d+\.\d+"
$tagName=$matches[0]
echo "Target version tag name $($tagName)"
git subtree split -P Build/Release -b upm
$tagBranchCommit=git log -n 1 upm --pretty=format:"%H"
echo "Git subtree commit $($tagBranchCommit)"
git push -f origin upm
$existingTag=git tag -l $tagName
if ($existingTag -eq $tagName)
{
	echo "Git tag $($tagName) already exists. Skip."
}
else
{
	git tag -a $tagName $tagBranchCommit -m "version $($tagName) tag"	
	git push origin $tagName
	echo "RELEASE_TAG=$tagName" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}

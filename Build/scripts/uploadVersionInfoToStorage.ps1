function GenerateIndexJson($ctx, $bundleVersion,$commitId, $fileName, $rootPath)
{
$filePath = Join-Path -Path $rootPath -ChildPath $fileName

$json = @"   
    {
        "version": "$BundleV1Template",
        "commitId" : "$commitId"
    }
"@

    $json | Out-File -FilePath $filePath -Encoding ascii
    $blobName = "ExtensionBundleTemplates\versions\" + $fileName
    Set-AzureStorageBlobContent -Container "public" -File $filePath -Blob $blobName -Context $ctx -Force

}

# get the build version
$BundleV1Template = "1.0." + $env:devops_buildNumber
$BundleV2Template = "2.0." + $env:devops_buildNumber
$BundleV3Template = "3.0." + $env:devops_buildNumber

$commitId = $(Build.SourceVersion)

$rootPath = $pwd

# Storage Context
$ctx = New-AzureStorageContext -StorageAccountName $env:ACCOUNT_NAME -SasToken $env:ACCOUNT_KEY

$fileName = "ExtensionBundle.v1.LastestVersion.json" 
GenerateIndexJson $ctx $BundleV1Template $commitId $fileName $rootPath

$fileName = "ExtensionBundle.v2.LastestVersion.json" 
GenerateIndexJson $ctx $BundleV1Template $commitId $fileName $rootPath

$fileName = "ExtensionBundle.v3.LastestVersion.json" 
GenerateIndexJson $ctx $BundleV1Template $commitId $fileName $rootPath
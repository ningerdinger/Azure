param(
      [Parameter()]
      [string]$GitHubDestinationPAT,

      [Parameter()]
      [string]$ADOSourcePAT
)
# Write your PowerShell commands here.
      Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
      Write-Host ' reflect Azure Devops repo changes to GitHub repo '
      Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
      $stageDir =  "C:\temp"#'$(Build.SourcesDirectory)' | Split-Path
      $githubDir = $stageDir +"\"+"gitHub"
      $destination = $githubDir +"\"+"Temp_Folder"
      #please provide your username
      $alias = 'some-owner:'+ "${GITHUB_PAT}"
      #Please make sure, you remove https from azure-repo-clone-url
      $sourceURL = 'https://' + $alias + '@github.com/some-owner/Source-Repo'
      $destURL = 'https://${AZUREDEVOPS_PAT}@dev.azure.com/Some_Org/Some_Porject/_git/Dest-Repo'
      if((Test-Path -path $githubDir))
      {
        Remove-Item -Path $githubDir -Recurse -force
      }
      if(!(Test-Path -path $githubDir))
      {
        New-Item -ItemType directory -Path $githubDir
        Set-Location $githubDir
        Write-Output '*****Cloning Github remote secondary****'
        git clone  $sourceURL -q
      }
      else
      {
        Write-Host "The given folder path $githubDir already exists";
      }
      Set-Location $destination
      Write-Output '*****Git removing remote secondary****'
      #git remote rm -q secondary 
      Write-Output '*****Git remote add****'
      git remote  add --mirror=fetch secondary  $destURL 
      
      Write-Output '*****Git fetch origin****'
      git fetch $sourceURL -q
     
      Write-Output '*****Git push secondary****'
 
      git push  secondary --all -q
     
      Write-Output '**Azure Devops repo synced with Github repo**'
      Set-Location $stageDir
      if((Test-Path -path $githubDir))
      {
        Remove-Item -Path $githubDir -Recurse -force
      }

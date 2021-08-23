## Introduction

This lab will create a Github Actions workflow to test custom plugin in CI pipeline and build luarock binary and upload to GitHub Artifacts automatically.


## Fork the repo

Click "Fork" in top right corner of this repo
![](assets/fork-repo.png)


## Add license data as GitHub secret (Optional)

Click "Setting" in your forked repo
![](assets/setting.png)

Click "Secrets" in sidebar then click "New repository secret"
![](assets/setting2.png)

Put name as "KONG_LICENSE_DATA" and value as your own license data. Then click "Add secret"
![](assets/add-secret.png)

Comment line 17 and uncomment line 18 & 19.

## Run workflow

For running workflow manually, click "Action" tab, then select "CI" under all workflows, after that click "Run workflow"
![](assets/run-workflow.png)

Or push and commit to master branch for running workflow automatically.

## Review result

After the pipeline runs, click into it.
![](assets/review-result.png)

There should have an artifact, download it.
![](assets/review-result2.png)

Unzip the downloaded zip file, you should see the rock binary file.
![](assets/review-result3.png)
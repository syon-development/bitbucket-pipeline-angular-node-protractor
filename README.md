# About
Based on  [pdouble16/bitbucket-pipeline-browsers].

## Additions / Changes
- Uses node image **10.16**.
- Installs **protractor**, **jasmine**  **jasmine-spec-reporter**, **@angular/cli** and 
**@nrwl/cli**.
- Runs **webdriver-manager update**.



## Setup Guide
Your *bitbucket-pipelines.yml* file should look like this:

    image:  syon-development/bitbucket-pipeline-angular-node-protractor
    pipelines:
        default:
            - step:
                  script:
                    - npm install
                    - [run test command]
[pdouble16/bitbucket-pipeline-browsers]: <https://hub.docker.com/r/pdouble16/bitbucket-pipeline-browsers/~/dockerfile/>

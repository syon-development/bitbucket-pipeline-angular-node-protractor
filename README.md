# About
Based on  [pdouble16/bitbucket-pipeline-browsers] and [adrianmarinica/bitbucket-pipelines-protractor]


Installs **protractor**, **jasmine**  **jasmine-spec-reporter**, **@angular/cli** and **@nrwl/cli**.
Runs **webdriver-manager update**.
Uses node version **10.16**


## Setup Guide
Your *bitbucket-pipelines.yml* file should look like this:

    image:  syon-development/bitbucket-pipeline-angular-node-protractor
    pipelines:
        default:
            - step:
                  script:
                    - npm install
                    - [run test command]
[adrianmarinica/bitbucket-pipelines-protractor]: <https://github.com/adrianmarinica/bitbucket-pipelines-protractor>
[pdouble16/bitbucket-pipeline-browsers]: <https://hub.docker.com/r/pdouble16/bitbucket-pipeline-browsers/~/dockerfile/>

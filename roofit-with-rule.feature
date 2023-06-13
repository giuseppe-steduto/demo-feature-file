# This file is part of REANA.
# Copyright (C) 2023 CERN.
#
# REANA is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

# This is a behavioural test file for the `reana-demo-root6-roofit` repository.

Feature: root6-roofit
  Background:
    Given the repository location is one of these:
      | repo                                                     | branch | specification                     |
      | testtesttesttesttesttest                                 | master | reana.yaml                        |

  Rule: roofit-related tests
    Background:
      Given the repository location is one of these:
        | repo                                                     | branch | specification                     |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana.yaml                        |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-cwl.yaml                    |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage.yaml                 |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-snakemake.yaml              |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-htcondorcern.yaml           |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-cwl-htcondorcern.yaml       |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage-htcondorcern.yaml    |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-snakemake-htcondorcern.yaml |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-slurmcern.yaml              |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-cwl-slurmcern.yaml          |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage-slurmcern.yaml       |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-snakemake-slurmcern.yaml    |

    Scenario: Files-related tests
      When the workflow is finished
      Then the workspace should include "results/data.root"
      And all the outputs should be included in the workspace
      And the workspace should contain "/code/fitdata.C"
      And the file "code/fitdata.C" should contain "RooWorkspace* w = (RooWorkspace*) f->Get("w")"
      And the sha256 checksum of the file "results/data.root" should be "c4a867640ce195032490f109d2ad3c5f5f2b2f64fb80f4b4a206aa84b5374206"
      And the size of the file "results/data.root" should be 154624 bytes

    Scenario: Log content
        Given the REANA specification file is <specification>
        When the workflow is finished
        Then the logs should contain "mkdir -p results && root -b -q"
        And the engine logs should contain "2023"
        And the job logs for the "fitdata" step should contain "5.00000e-01"
        And the job logs for the "gendata" step should contain
          """
          datasets
          --------
          RooDataSet::modelData(x)
          """


  Rule: yadage-specific
    Background:
      Given the repository location is one of these:
        | repo                                                     | branch | specification               |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage.yaml           |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage-htcondor.yaml  |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | test   | reana-yadage-slurmcern.yaml |

    Scenario: Reports
      When the workflow is finished
      Then the workspace should contain "workflow.gif"
      And the duration of the workflow should be less than 10 minutes


  Rule: htcondor-specific
    Scenario: Singularity created
      Given the repository location is one of these:
        | repo                                                     | branch | specification                      |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-htcondorcern.yaml            |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-cwl-htcondorcern.yaml        |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-snakemake-htcondorcern.yaml  |
        | https://github.com/reanahub/reana-demo-alice-pt-analysis | master | reana-yadage-htcondorcern.yaml     |
      And the repository branch name is "yadage"
      When the workflow is finished
      Then the workspace should contain reana_job.[0-9]+.out

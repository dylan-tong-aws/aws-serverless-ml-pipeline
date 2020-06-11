This is a desired list of enhancements. It's not currently ordered by priority:

1. Build data drift monitoring baseline as part of the training process.
2. Deploy a seperate endpoint as part of the production deployment.
3. Track and fix data capture issue.
4. Track and fix VPC endpoint issues. (https://t.corp.amazon.com/P35965298/overview)
5. General UX improvements:
      * Configuration interface.
      * ...
6. Implement better granular pipeline triggers, so that only selective files trigger pipeline runs.
7. Provide reporting capabilities to unify code and model lineage currently tracked by disparate systems: CodeCommit and SageMaker Experiments.
8. Provide simplified end-to-end rollback UX. 
9. Add more drop in ML pipeline templates eg. HPO
10. Replace the default ml pipeline training step with an Autopilot job once it is supported by the Data Science SDK.

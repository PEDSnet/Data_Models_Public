## Contributing

Thank you for considering a contribution to the PEDSnet Data Models! This document is a guide to best practices. If you are already comfortable with using `git`, the summary sections under each use case should be enough to guide your work. If you would like more specific instructions, the example commands section under each use case should help you along. Please post any issues you have [here](https://github.com/PEDSnet/Data_Models/issues).

### Contributing to the PEDSnet CDM

The PEDSnet CDM is made up of the CDM documentation, the ETL specifications, and the CDM and Vocabulary DDL generation tools. If you would like to make a contribution to the development of these resources (for network-wide consideration), please use the following procedures.

#### Summary

1. Create a branch with a descriptive name (`fix-grammar`) or an issue number name (`issue-14` if there is an issue related to your contribution).
2. Make whatever edits you feel are appropriate, commit them, and push your new branch to the origin.
3. Submit a pull request from your new branch to the `master` branch.
4. If additional edits are required, use `git commit --amend` to add them to your existing changes and `git push --force` to update the remote branch.

#### Example Commands

```bash
git clone https://github.com/PEDSnet/Data_Models.git    # Clone the Data_Models repo to your local machine (if you haven't already)
cd Data_Models/PEDSnet                                  # Change into the PEDSnet CDM directory
git checkout master                                     # Ensure you are on the master branch (unnecessary if you just cloned the repo for the first time)
git pull                                                # Ensure you have the most recent updates from the central repository (what you see on GitHub, also called the origin)
git checkout -b fix-grammar                             # Create and switch into a new branch named fix-grammar
vim docs/PEDSnet_CDM_V1.md                              # Edit the PEDSnet CDM documentation markdown file (feel free to use your editor of choice instead of vim)
mark docs/PEDSnet_CDM_V1.md                             # OPTIONAL Use Marked2 to preview the file (helps catch markdown formatting errors; http://marked2app.com/)
git add docs/PEDSnet_CDM_V1.md                          # Stage your changed file for commit
git commit                                              # Commit your changes (please write a meaningful commit message: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
git push -u origin fix-grammar                          # Push your new branch up to the origin
```

At this point, go to the [branches page](https://github.com/PEDSnet/Data_Models/branches), find your new branch, click the `Pull Request` button, edit the title or description as desired, and submit the pull request (PR). After submitting the PR, you can view it (and the lively discussion it hopefully attracts) by clicking on it in the [pull request page](https://github.com/PEDSnet/Data_Models/pulls). If edits are suggested, use the following commands to make them.

```bash
vim docs/PEDSnet_CDM_V1.md                              # Add suggested edits the PEDSnet CDM documentation markdown file
mark docs/PEDSnet_CDM_V1.md                             # OPTIONAL Use Marked2 to preview the file as it will display on GitHub (http://marked2app.com/)
git add docs/PEDSnet_CDM_V1.md                          # Stage your new changes for commit
git commit --amend                                      # Add your new changes to the previous commit, editing the message if required (this helps to keep all your logically grouped changes together)
git push --force                                        # Push your new, amended commit, up to your branch on the origin, replacing the outdated commit
```

When consensus is reached about the changes in your PR, one of the repository owners will merge it into the master branch and delete your branch. Use the following commands to update your local version of the `master` branch and delete your branch locally.

```bash
git checkout master                                     # Switch to the master branch
git pull                                                # Retrieve the latest changes (your merged edits) from the origin and update your local version with them
git br -D fix-grammar                                   # Delete your local version of the fix-grammar branch
git br -Dr origin/fix-grammar                           # Delete your your local mirror of the fix-grammar branch on the origin
```

### Maintaining Site-Specific Annotations

The PEDSnet CDM and associated documents cover as much of the process of extracting data from source systems into the CDM as possible, but many ETL decisions have been left to the sites. Some sites may wish to document their site-specific decisions by maintaining a separate but related version of the CDM and associated documents that includes annotations covering these decisions. The best way to do this is with a persistent site-specific branch of the Data Models repository. Please use the following procedures to accomplish this.

#### Summary

1. Create a branch using your site name (eg `boston-annotations`).
2. Make whatever edits you feel are appropriate, commit them, and push the branch to the origin.
3. When the master branch is updated, merge those changes into your site annotation branch.
4. If another collaborator pushes changes to your site annotation branch, rebase any in progress edits you have locally onto the updated branch from the origin.

#### Example Commands

```bash
git clone https://github.com/PEDSnet/Data_Models.git    # Clone the Data_Models repo to your local machine (if you haven't already)
cd Data_Models/PEDSnet                                  # Change into the PEDSnet CDM directory
git checkout master                                     # Ensure you are on the master branch (unnecessary if you just cloned the repo for the first time)
git pull                                                # Ensure you have the most recent updates from the central repository (what you see on GitHub, also called the origin)
git checkout -b boston-annotations                      # Create and switch into a new branch named boston-annotations
vim docs/PEDSnet_CDM_V1_ETL_Conventions.md              # Edit the PEDSnet ETL conventions markdown file (feel free to use your editor of choice instead of vim)
mark docs/PEDSnet_CDM_V1_ETL_Conventions.md             # OPTIONAL Use Marked2 to preview the file (helps catch markdown formatting errors; http://marked2app.com/)
git add docs/PEDSnet_CDM_V1_ETL_Conventions.md          # Stage your changed file for commit
git commit                                              # Commit your changes (please write a meaningful commit message: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
git push -u origin boston-annotations                   # Push your new branch up to the origin
```

If the master branch is updated, use the following steps to merge the new changes with your site annotations branch.

```bash
git checkout master                                     # Switch onto the master branch
git pull                                                # Update your local copy of the master branch with the new changes from the origin
git checkout boston-annotations                         # Switch back to the boston-annotations branch
git merge master                                        # Kick off the process of merging the changes in master with your site annotations
vim docs/PEDSnet_CDM_V1_ETL_Conventions.md              # Resolve any merge conflicts that arise (could be in any files you've edited, or none) (see https://help.github.com/articles/resolving-a-merge-conflict-from-the-command-line/)
git add docs/PEDSnet_CDM_V1_ETL_Conventions.md          # Stage the edits which resolve the merge conflicts for commit (unnecessary if no merge conflicts arose)
git commit                                              # Finish the merge commit (unnecessary if no merge conflicts arose)
git push                                                # Push the new edits (which merge in the changes from master) up to the origin
```

If another collaborator pushes changes to the site annotations branch while you have local changes, use the following steps to pull the new changes into your local repo without losing your edits.

```bash
git checkout boston-annotations                         # Switch to the site annotations branch
git add docs/PEDSnet_CDM_V1_ETL_Conventions.md          # Stage you local changes for commit (if you have uncommitted changes)
git commit                                              # Commit your local changes (if you have uncommitted changes)
git fetch                                               # Get you collaborator's changes from the origin, without merging them into your local branch
git rebase origin/boston-annotations                    # Kick off a "rebase" process which will pick up your local changes and insert your collaborators changes before them in the commit history
vim docs/PEDSnet_CDM_V1_ETL_Conventions.md              # Resolve any rebase conflicts that arise (could be in any files you've edited, or none) (see https://help.github.com/articles/resolving-a-merge-conflict-from-the-command-line/)
git add docs/PEDSnet_CDM_V1_ETL_Conventions.md          # Stage the edits which resolve the rebase conflicts for commit (unnecessary if no conflicts arose)
git rebase --continue                                   # Finish the rebase (unnecessary if no conflicts arose)
vim docs/PEDSnet_CDM_V1_ETL_Conventions.md              # Continue making your local edits that were in progress
git add docs/PEDSnet_CDM_V1_ETL_Conventions.md          # Stage your new local edits for commit
git commit --amend                                      # Add your new local edits to the commit that was in progress before the rebase
git push                                                # Push your new commit to the origin
```

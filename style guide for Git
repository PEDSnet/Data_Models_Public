# Style Guide for Git

### Issue Labels

When creating a new repository, follow the recommendations below to keep your issue labels consistent across all PEDSnet sites and projects.

#### Prefixes

Labels should begin with one of the following prefixes:

- `version` indicates the version of the codebase that the issue is related to.
    - default label color: `#009800` (green)
- `type` indicates whether the issues is a bug, feature request, etc.
    - default label color: `#207de5` (blue)
- `status` indicates whether the issue will be fixed, is deferred, etc.
    - default label color: `#a9a9a9` (grey)
- `domain` indicates the PEDSnet domain
    - default label color: `#eb6420` (orange)

Prefixes and the label name suffix should be separated by a colon. For example, `version:2.1`. All labels with a common prefix should be the same color unless otherwise defined below for particular labels.

#### Version Labels (required)

Version labels should follow the rules below. Each issue must have an version label applied to it.

- `version:N.M` Applies directly to the `N.M` release version.
- `version:future` Does not relate to any planned release version and will be worked on at sometime in the future. These should be reclassified as new versions are planned.

Note, the _current_ minor version label (e.g. `version:2.0`) will have a distinct color: `#fbca04` (goldenrod).

#### Type Labels (required)

Type labels for the repository should be limited to those that appear below. Each issue must have a type issue applied to it.

- `type:bug` A a problem with the existing code base. Bugs should contain detailed steps on recreating the bug and the environment in which it was encountered.
    - label color: `#e11d21` (red)
- `type:feature` A feature request. These types of issues should fully explain the feature being requested and, if needed, solicit for input from the developers on implementation approaches.
- `type:refactor` Refactoring of the code base. This does not include any new features and does not fix any bugs.
- `type:docs` Applicable for issues related to documentation of any kind be it documenting the code or otherwise.
- `type:community` Catch all for improvement of community-based items such as communication methods, updating contributing docs, planning meetups, etc.
- `type:idea` A general idea needing more discussion and refinement. This is _NOT_ a feature request. Issues with this label are simply abstract ideas related to the project and may later result in new feature requests but these issues are merely meant to serve as a discussion forum for evaluating and refining the idea itself.

#### Status Labels (optional)

Status labels for the repository should be limited to those that appear below:

- `status:wontfix` This issue will not be worked on. This might be because it is a duplicate, it could not be confirmed, etc.
- `status:deferred` This issue cannot be finished right now. This might be applied when the issue doesn't relate to the current release, it isn't important to fix immediately, etc.
- `status:needinfo` More information is required before this issue can be addressed. This status will often be applied to bugs that are not reproduceable because reproduction steps are missing but also applies to inadequately explained feature requests, etc.
    - label color: `#e11d21` (red)

Issues are not required to have a status label because of the following assumptions:

- Closed issues _not_ marked as _status:wontfix_ are assumed to be resolved.
- Issues without a type are assumed _not_ to be confirmed. When one of the developers reviews the ticket and adds a type and version, it is assumed to be _confirmed_.

### Branching

Follow the [git branching model](http://nvie.com/posts/a-successful-git-branching-model/)

- `master` should generally not be worked on directly unless they are non-functional or trivial changes and apply project-wide
- Create separate branches off of `master` for each feature and to isolate a set of fixes. In most cases a branch will be created based on an existing ticket. Name the branch `issue-NNN` using the ticket number.
- Each commit in a branch should perform a meaningful set of changes. Rebase the branch to `fixup` (combine with previous) any commmits that are minor fixes that should have been included in the parent commit.
- Rebase branches against `master` leading up to merging to ensure there are no conflicts.

### Commit Messages

Largely influenced by Tim Pope's [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) (good read).

- The first line (subject) of a commit message should be no longer than 70 characters; add the remaining to the body of the message. It is suggested that each line in the body should not exceed 80 characters (like code) so commit messages are formatted well in a console.
- Commit messages should be _present tense_ since the commit message is a description of what _has_ happened (in that commit), not what _had_ happened
    - e.g. "Fix missing local reference to `foo`", not "Fixed" or "Fixing"
- If a commit is intended to be visible in the history, it must have a meaningful commit message
    - This _should not_ require others to look at the code to generally understand what changed. Release notes are created based off the commit messages, so they must be informative.
- For bad commits that require a subsequent "fixed", "fixing", "whoops" commit message use `git commit --amend` to ammend the previous commit
    - On a side note, if you already pushed the commit you need to ammend, you can do `git push --force` for _your_ branch to force overwriting thte commit on the server. Be aware of the impact of this if other developers are working on the same branch.

### General Workflow

- [Useful GitHub Patterns](http://blog.quickpeople.co.uk/2013/07/10/useful-github-patterns/)
- [GitHub Flow in the Browser](https://github.com/blog/1557-github-flow-in-the-browser)

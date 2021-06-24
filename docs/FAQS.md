## FAQS

Here's a compilation of Frequently Asked Questions (FAQs). Feel free to add to our FAQs by raising a Pull Request (PR).

---

## Azure Commands

### My command isn't recognised and I got the following error, how do I get it to work?

- When copying and pasting commands from Github viewed on a browser, the formatting can result in the command not being recognised in your terminal.

- We recommend you try to copy and paste the command from your code editor instead e.g. Visual Studio Code, Notepad++ etc.

- While you're learning, we encourage you to type commands out by hand so that you can reinforce your knowledge a bit better.

---

## Terraform

### Terraform apply produced an error, what can I try next?

- If you get an error during `terraform apply`, let's determine if it's just a one-off issue or does the command fail consistently in the same place i.e. can you reproduce the error messages?

- Run `terraform apply` again to see what outcome you get.

- You can also try to run `terraform destroy` first and then run `terraform apply` again.

---

### How do I remove Terraform's state to start afresh again?

- When you want a blank slate to work from, it is advisable to ensure that the state has been fully cleared down.

- Run `terraform destroy`

- Once that's complete run:

```bash
rm -rf .terraform
```
- And then run:

```bash
rm -rf terraform.tfstate*
```

---

### Where do I run the `terraform destroy` command?

- You need to run the `terraform destroy` command from the location where your terraform config is

---

## Branching & Git

### I'm trying to checkout onto the `session-004-gitops` branch but I got the following error, can you give me some pointers on how to troubleshoot?

```bash
error: pathspec 'session-004-gitops' did not match any file(s) known to git
hint: 'session-004-gitops' matched more than one remote tracking branch.
hint: We found 2 remotes with a reference that matched. So we fell back
hint: on trying to resolve the argument as a path, but failed there too!
```

- During the DevOps Upskill program, you will be asked to fork any relevant repositories. A fork is a copy of a repository that allows you to freely experiment with changes without affecting the original project. You can read more about the difference between a fork and a clone [here](https://github.community/t/the-difference-between-forking-and-cloning-a-repository/10189).

- To ensure you can checkout onto your forked repository's `session-004-gitops` branch rather than the upstream `session-004-gitops` branch, run the following git commands to check you have the correct origin and upstream set:

- Run:

```bash
git branch -r
```

- You should see something like this:

```bash
origin/HEAD -> origin/main
origin/main
origin/session-004-gitops
upstream/main
upstream/session-004-gitops
```

- Run:

```bash
git remote -v
```

You should see something like this:

```bash
origin  https://github.com/{yourgithubname}/devops-upskill-aks-terraform.git (fetch)
origin  https://github.com/{yourgithubname}/devops-upskill-aks-terraform.git (push)
upstream        https://github.com/techreturners/devops-upskill-aks-terraform.git (fetch)
upstream        https://github.com/techreturners/devops-upskill-aks-terraform.git (push)
```

- Next, ensure you fetch any latest changes and checkout the latest version of the upstream branch and now checkout that version onto your local branch.

- Run:

```bash
git fetch upstream
git checkout upstream/session-004-gitops
git checkout -b session-004-gitops
```

---

## Argo

### I’m getting invalid password/username when trying to log into Argo. Has anyone else had this?

- The instructions mentioned that the first password may fail. We recommend you try a different command to get a different password. The second one usually works (make sure you remove the % character at the end if it's there).

---
# Give Up GitHub

This project has given up GitHub.  ([See Software Freedom Conservancy's *Give Up  GitHub* site for details](https://GiveUpGitHub.org).)

You can now find this project at [git.chuso.net](https://git.chuso.net/chuso/chuso-overlay) instead.

Any use of this project's code by GitHub Copilot, past or present, is done without my permission.  I do not consent to GitHub's use of this project's code in Copilot.

Join us; you can [give up GitHub](https://GiveUpGitHub.org) too!

![Logo of the GiveUpGitHub campaign](https://sfconservancy.org/img/GiveUpGitHub.png)

# Update configuration to new URL

To update your Portage configuration to use the new repository URL, you first need to remove the old repository:

* If you had added it with `eselect-repository`, you can delete it with:
  ```
  eselect repository remove chuso-overlay
  ```

* If you had added it with `layman`, you can deleted it with:
  ```
  layman -d chuso-overlay
  ```

* If you have used neither `eselect-repository` nor `layman`, you may have added the repository manually and you will need to revert whatever steps you followed to install it in the first place. That may involve deleting the corresponding file from `/etc/portage/repos.conf` or entry line from `/etc/portage/make.conf` or `/etc/make.comf`.

After you have deleted the old version of the repository, you can re-add it with the new URL using `eselect-repository`:

```
eselect repository add chuso-overlay git https://git.chuso.net/chuso/chuso-overlay.git
```

If you don't have the `repository` module for `eselect`, you can install it by merging `app-eselect/eselect-repository` package:

```
emerge app-eselect/eselect-repository
```

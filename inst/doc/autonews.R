## ----creategit----------------------------------------------------------------
library(autonewsmd)

# (Example is based on the public examples from the `git2r` R package)
## Initialize a repository
path <- file.path(tempdir(), "autonewsmd")
dir.create(path)
repo <- git2r::init(path)

## Config user
git2r::config(repo, user.name = "Alice", user.email = "alice@example.org")
git2r::remote_set_url(repo, "foobar", "https://example.org/git2r/foobar")


## Write to a file and commit
lines <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do"
writeLines(lines, file.path(path, "example.txt"))

git2r::add(repo, "example.txt")
git2r::commit(repo, "feat: new file example.txt")

## Write again to a file and commit
Sys.sleep(2) # wait two seconds, otherwise, commit messages have same time stamp
lines2 <- paste0(
  "eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris ",
  "nisi ut aliquip ex ea commodo consequat."
)
write(lines2, file.path(path, "example.txt"), append = TRUE)

git2r::add(repo, "example.txt")
git2r::commit(repo, "refactor: added second phrase")

## Also add a tag here
git2r::tag(repo, "v0.0.1")


## ----instantiatenmd-----------------------------------------------------------
an <- autonewsmd$new(repo_name = "TestRepo", repo_path = path)
an$generate()


## ----viewrepolist-------------------------------------------------------------
# View the list
an$repo_list
#> $v0.0.1
#> $v0.0.1$commits
#>                                         sha                       summary                       message author
#> 1: c75e13af49dd99ab70f621717c4bf585001b82d0 refactor: added second phrase refactor: added second phrase  Alice
#> 2: f66d96d2362df21a0685b3636b43438f51814455    feat: new file example.txt    feat: new file example.txt  Alice
#>                email                when sha_seven         type        clean_summary    tag tag_before
#> 1: alice@example.org 2022-09-02 06:31:20   c75e13a Refactorings  added second phrase v0.0.1     v0.0.1
#> 2: alice@example.org 2022-09-02 06:31:18   f66d96d New features new file example.txt v0.0.1       <NA>
#>
#> $v0.0.1$latest_date
#> [1] "2022-09-02"
#>
#> $v0.0.1$sha_from
#> [1] "f66d96d2362df21a0685b3636b43438f51814455"
#>
#> $v0.0.1$sha_to
#> [1] "c75e13af49dd99ab70f621717c4bf585001b82d0"
#>
#> $v0.0.1$tag_from
#> [1] "f66d96d"
#>
#> $v0.0.1$tag_to
#> [1] "v0.0.1"
#>
#> $v0.0.1$full_changes
#> [1] "Full set of changes: [`f66d96d...v0.0.1`](https://example.org/git2r/foobar/compare/f66d96d...v0.0.1)"


## ----writenmd-----------------------------------------------------------------
an$write(force = TRUE)
#> processing file: autonewsmd-5272f03178-news-md-template.qmd
#> output file: autonewsmd-5272f03178-news-md-template.knit.md
#> /usr/lib/rstudio-server/bin/quarto/bin/tools/pandoc +RTS -K512m -RTS autonewsmd-5272f03178-news-md-template.knit.md --to markdown_strict-yaml_metadata_block --from markdown+autolink_bare_uris+tex_math_single_backslash --output /tmp/RtmpY9K0uU/autonewsmd/NEWS.md
#>
#> Output created: /tmp/RtmpY9K0uU/autonewsmd/NEWS.md


## ----listfiles----------------------------------------------------------------
list.files(path)
#> [1] "example.txt" "NEWS.md"


## ----readnmd------------------------------------------------------------------
newsmd <- readLines(file.path(path, "NEWS.md"))
newsmd
#>  [1] "# TestRepo NEWS"
#>  [2] ""
#>  [3] "## v0.0.1 (2022-09-02)"
#>  [4] ""
#>  [5] "#### New features"
#>  [6] ""
#>  [7] "-   new file example.txt"
#>  [8] "    ([f66d96d](https://example.org/git2r/foobar/tree/f66d96d2362df21a0685b3636b43438f51814455))"
#>  [9] ""
#> [10] "#### Refactorings"
#> [11] ""
#> [12] "-   added second phrase"
#> [13] "    ([c75e13a](https://example.org/git2r/foobar/tree/c75e13af49dd99ab70f621717c4bf585001b82d0))"
#> [14] ""
#> [15] "Full set of changes:"
#> [16] "[`f66d96d...v0.0.1`](https://example.org/git2r/foobar/compare/f66d96d...v0.0.1)"


## ----addnmd-------------------------------------------------------------------
Sys.sleep(2)
git2r::add(repo, "NEWS.md")
git2r::commit(repo, "chore: added news.md file")
#> [07b6c39] 2022-09-02: chore: added news.md file
an$generate()
an$write(force = TRUE)
#> processing file: autonewsmd-52215e4b2b-news-md-template.qmd
#> output file: autonewsmd-52215e4b2b-news-md-template.knit.md
#> /usr/lib/rstudio-server/bin/quarto/bin/tools/pandoc +RTS -K512m -RTS autonewsmd-52215e4b2b-news-md-template.knit.md --to markdown_strict-yaml_metadata_block --from markdown+autolink_bare_uris+tex_math_single_backslash --output /tmp/RtmpY9K0uU/autonewsmd/NEWS.md
#>
#> Output created: /tmp/RtmpY9K0uU/autonewsmd/NEWS.md


## ----readnmd2-----------------------------------------------------------------
newsmd <- readLines(file.path(path, "NEWS.md"))
newsmd
#>  [1] "# TestRepo NEWS"
#>  [2] ""
#>  [3] "## Unreleased (2022-09-02)"
#>  [4] ""
#>  [5] "#### Other changes"
#>  [6] ""
#>  [7] "-   added news.md file"
#>  [8] "    ([07b6c39](https://example.org/git2r/foobar/tree/07b6c390bf728cf6e19a991dabe7cb8f1cad1ad6))"
#>  [9] ""
#> [10] "## v0.0.1 (2022-09-02)"
#> [11] ""
#> [12] "#### New features"
#> [13] ""
#> [14] "-   new file example.txt"
#> [15] "    ([f66d96d](https://example.org/git2r/foobar/tree/f66d96d2362df21a0685b3636b43438f51814455))"
#> [16] ""
#> [17] "#### Refactorings"
#> [18] ""
#> [19] "-   added second phrase"
#> [20] "    ([c75e13a](https://example.org/git2r/foobar/tree/c75e13af49dd99ab70f621717c4bf585001b82d0))"
#> [21] ""
#> [22] "Full set of changes:"
#> [23] "[`f66d96d...v0.0.1`](https://example.org/git2r/foobar/compare/f66d96d...v0.0.1)"


## ----fn-----------------------------------------------------------------------
an$file_name
#> [1] "NEWS"


## ----fe-----------------------------------------------------------------------
an$file_ending
#> [1] ".md"


## ----tp-----------------------------------------------------------------------
an$tag_pattern
#> [1] "^v(\\d+\\.){2}\\d+(\\.\\d+)?$"


## ----nolintend, include=FALSE-------------------------------------------------
# nolint end


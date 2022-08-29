## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

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

## ----writenmd-----------------------------------------------------------------
an$write()

## ----listfiles----------------------------------------------------------------
list.files(path)

## ----readnmd------------------------------------------------------------------
newsmd <- readLines(file.path(path, "NEWS.md"))
newsmd

## ----addnmd-------------------------------------------------------------------
Sys.sleep(2)
git2r::add(repo, "NEWS.md")
git2r::commit(repo, "chore: added news.md file")
an$generate()
an$write()

## ----readnmd2-----------------------------------------------------------------
newsmd <- readLines(file.path(path, "NEWS.md"))
newsmd

## ----fn-----------------------------------------------------------------------
an$file_name

## ----fe-----------------------------------------------------------------------
an$file_ending

## ----tp-----------------------------------------------------------------------
an$tag_pattern


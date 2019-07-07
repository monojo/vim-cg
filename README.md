# Function Call relations based on cscope
---

## Introduction

This plugin use python scripts as backend to build function call relationships based on cscope database. 
The python script is from [makelinux](https://github.com/makelinux/linux_kernel_map/blob/master/srcxray.py)

## Usage

Currently, you have to make sure that the cscope database is located at where you run
vim. Put it at the root of the project.

`<leader>ct` to generate a call tree
`<leader>rt` to generate a reference tree

## Config

`let g:cscope_vim_level_limit = 4` controls the graph level

## TODO

- When regenerate call graph from code, do not create new window. Make it feel
  like refresh on the current window.
- Make list foldable
- Non editable
- Jumpable
- When hit on ..., let it show more content.
- Manage cscope database

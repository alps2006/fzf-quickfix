# fzf :heart: quickfix

![](https://user-images.githubusercontent.com/25827968/63228948-0d8ff100-c1fb-11e9-95d8-e5df195ba18e.png)

forked from fszymanski/fzf-quickfix

## Requirements
- [fzf](https://github.com/junegunn/fzf)

## Installation

Using the (Neo)vim built-in (kind of) plugin manager:

```sh
$ cd path/to/pack/foo/start
$ git clone https://github.com/fszymanski/fzf-quickfix.git
```

Using your favorite (Neo)vim plugin manager:

```vim
Plug 'alps2006/fzf-quickfix', {'on': 'Quickfix'}

nnoremap <Leader>q :Quickfix<CR>
nnoremap <Leader>l :Quickfix!<CR>

```

Highlight search text

```vim
:Quickfix search_text<CR>
:Quickfix! search_text<CR>

```

## Documentation

For more information, see `:help fzf_quickfix.txt`.

## License

MIT

# cairo-support-nvim

## Details

get compile errors and format documents to cairo

install using Packer
```
use({ "racso2609/cairo-support-nvim" })
// disable or enable the support
cairo.setup({
	format = true,
	compile = true,
  // pyenv enviroment name
  enviroment = "cairo"
})
```
## Dependencies
	1. starknet-devnet
	2. cairo-lang
  3. pyenv

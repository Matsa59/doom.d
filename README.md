# Doom emacs configuration

## Configure elixir

Install elixir-ls and set path like:

``` emacs-lisp
(setq exec-path (append exec-path '("~/Code/elixir/elixir-ls/release")))
```


## JS

You'll need to install typescript and typescript-language-server

``` sh
npm install -g typescript typescript-language-server
```

> Be sure to have a `jsconfig.json` in your root of your project otherwise it will crash
> with a timed out error.


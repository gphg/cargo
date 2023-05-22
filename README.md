Cargo
===

Cargo makes it easy to manage assets in a Love2D project by exposing project directories as Lua tables.
This means you can access your files from a table automatically without needing to load them first.
Assets are lazily loaded, cached, and can be nested arbitrarily.

You can also manually preload sets of assets at a specific time to avoid loading hitches.

[**Simplified**](https://github.com/gphg/cargo): It returns string to file. No loader involved.
Original of this repo fork can be found [here](https://github.com/bjornbytes/cargo)

You can also do the following to expose your entire project as part of the Lua global scope:

```lua
setmetatable(_G, {
  __index = require('cargo').init('/')
})
```

Advanced
---

There are two ways to tell cargo to load a directory. The first is by passing in the name of the directory you want to load:

```lua
assets = cargo.init('my_assets')
```

The second is by passing in an options table, which gives you more power over how things are loaded:

```lua
assets = cargo.init({
  dir = 'my_assets',
  processors = {
    ['images/'] = function(filename)
      -- filename is string, do somethig with filename here
    end
  }
})
```

After something has been loaded, you can set it to `nil` to clear it from the cargo table.  Note
that it will only be garbage collected if nothing else references it.

You can also preload all of the assets in a cargo table by calling it (or any of its children) as a function:

```lua
assets = cargo.init('media')()     -- Load everything in 'media'
assets = cargo.init('media')(true) -- Load everything in 'media', recursively

assets.sound.background()          -- Preload all of the background music
```

### Processors

Sometimes, it can be helpful to do some extra processing on assets after they are loaded.
This extra work can be configured by the `processors` option.
The keys are Lua patterns that match filenames, and the values are functions that get passed the path to filename of the asset.

License
---

MIT, see [`LICENSE`](LICENSE) for details.

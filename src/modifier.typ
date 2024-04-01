/// A path modifier is a function that accepts a contex, style and
/// a single drawable and returns a single (modifierd) drawable.

/// Apply a path modifier to a list of drawables
///
/// - ctx (context):
/// - style (style):
/// - drawables (array): List of drawables (paths)
#let apply-modifier-fn(ctx, style, drawables, fn) = {
  let fn = if type(name-or-fn) == function {
    name-or-fn
  } else {
    ctx.path-modifiers.at(name-or-fn, default: none)
  }

  assert(type(fn) == function,
    message: "Path modifier must be of type function.")

  return drawables.map(d => {
    // ...
    return d
  }).filter(none)
}

/// Apply a path modifier to a list of drawables
#let apply-path-modifier(ctx, style, drawables) = {
  let fns = if type(style.decoration) == array {
    style.decoration
  } else {
    (style.decoration,)
  }.map(n => {
    if type(n) == str {
      assert(n in ctx.path-modifiers,
        message: "Unknown path-modifier: " + repr(n))
      ctx.path-modifiers.at(n)
    } else {
      n
    }
  })

  // Unset decorations to prevent unwanted recursion
  style.decoration = ()

  // Apply function on all drawables
  return drawables.map(d => {
    for fn in fns {
      d = apply-modifier-fn(ctx, style, fn)
    }
    return d
  })
}

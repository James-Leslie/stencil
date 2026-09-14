# web

Plain Svelte 5 and Vite, not SvelteKit. `src/routes/` is an ordinary folder with
no routing behaviour of its own: the router is `src/lib/router.svelte.ts` and the
table is the `{#if}` chain in `src/App.svelte`. Adding a page means a component
and a branch there.

`src/lib/api.ts` is the only place that calls `fetch`. Every request goes to
`/api`, which Vite proxies in dev and Vercel rewrites in production.

## Comments

The root rule applies. Here that usually means a Pico or browser behaviour
that would look like a mistake.

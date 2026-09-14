<script lang="ts">
  import { api, errorMessage, type Health } from '../lib/api'
  import { isDark, toggleTheme } from '../lib/theme.svelte'

  // Proves the whole path end to end: Vite's proxy in dev, the host's routing
  // in production, and FastAPI at the other end of it.
  let health = $state.raw<Health | null>(null)
  let failure = $state('')

  $effect(() => {
    api
      .health()
      .then((result) => (health = result))
      .catch((error) => (failure = errorMessage(error)))
  })
</script>

<article>
  <header>
    <hgroup>
      <h1>Stencil</h1>
      <p>FastAPI and Svelte, sharing one origin.</p>
    </hgroup>
  </header>

  <p>
    Backend:
    {#if failure}
      <mark>{failure}</mark>
    {:else if health}
      <code>{health.status}</code>
    {:else}
      <span aria-busy="true">checking</span>
    {/if}
  </p>

  <footer>
    <button class="secondary" onclick={toggleTheme}>
      Switch to {isDark() ? 'light' : 'dark'}
    </button>
  </footer>
</article>

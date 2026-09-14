<script lang="ts">
  import { path } from './lib/router.svelte'
  import Home from './routes/Home.svelte'
</script>

<main class="container">
  <!-- The routing table. Adding a page means a component and a branch here. -->
  {#if path() === '/'}
    <Home />
  {:else}
    <article>
      <h1>Not found</h1>
      <p><a href="/">Back home</a></p>
    </article>
  {/if}
</main>

import { svelte } from '@sveltejs/vite-plugin-svelte'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [svelte()],
  server: {
    // In production the host routes /api to the backend. Locally the two
    // servers are separate origins, so proxy to keep them one origin,
    // otherwise a session cookie wouldn't be sent.
    proxy: {
      '/api': 'http://127.0.0.1:8000',
    },
  },
})

<script lang="ts">
import {defineComponent} from "vue";
import {message} from "@tauri-apps/api/dialog";

export default defineComponent({
  mounted() {
    message("Hello. Please click ok to continue", "Welcome Message").then(() => console.log("Hi"))
  }
})


</script>

<template>
  <header>
  </header>

  <main>

  </main>
</template>

<style scoped>
 
</style>
